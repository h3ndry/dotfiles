local ls = require("luasnip")
-- some shorthands...
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local l = require("luasnip.extras").lambda
local r = require("luasnip.extras").rep
local p = require("luasnip.extras").partial
local m = require("luasnip.extras").match
local n = require("luasnip.extras").nonempty
local dl = require("luasnip.extras").dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local types = require("luasnip.util.types")
local conds = require("luasnip.extras.expand_conditions")

-- Every unspecified option will be set to the default.
ls.config.set_config(
  {
    history = true,
    -- Update more often, :h events for more info.
    updateevents = "TextChanged,TextChangedI",
    ext_opts = {
      [types.choiceNode] = {
        active = {
          virt_text = {{"choiceNode", "Comment"}}
        }
      }
    },
    -- treesitter-hl has 100, use something higher (default is 200).
    ext_base_prio = 300,
    -- minimal increase in priority.
    ext_prio_increase = 1,
    enable_autosnippets = true
  }
)

-- args is a table, where 1 is the text in Placeholder 1, 2 the text in
-- placeholder 2,...
local function copy(args)
  return args[1]
end

-- 'recursive' dynamic snippet. Expands to some text followed by itself.
local rec_ls
rec_ls = function()
  return sn(
    nil,
    c(
      1,
      {
        -- Order is important, sn(...) first would cause infinite loop of expansion.
        t(""),
        sn(nil, {t({"", "\t\\item "}), i(1), d(2, rec_ls, {})})
      }
    )
  )
end

-- complicated function for dynamicNode.
local function jdocsnip(args, _, old_state)
  local nodes = {
    t({"/**", " * "}),
    i(1, "A short Description"),
    t({"", ""})
  }

  -- These will be merged with the snippet; that way, should the snippet be updated,
  -- some user input eg. text can be referred to in the new snippet.
  local param_nodes = {}

  if old_state then
    nodes[2] = i(1, old_state.descr:get_text())
  end
  param_nodes.descr = nodes[2]

  -- At least one param.
  if string.find(args[2][1], ", ") then
    vim.list_extend(nodes, {t({" * ", ""})})
  end

  local insert = 2
  for indx, arg in ipairs(vim.split(args[2][1], ", ", true)) do
    -- Get actual name parameter.
    arg = vim.split(arg, " ", true)[2]
    if arg then
      local inode
      -- if there was some text in this parameter, use it as static_text for this new snippet.
      if old_state and old_state[arg] then
        inode = i(insert, old_state["arg" .. arg]:get_text())
      else
        inode = i(insert)
      end
      vim.list_extend(nodes, {t({" * @param " .. arg .. " "}), inode, t({"", ""})})
      param_nodes["arg" .. arg] = inode

      insert = insert + 1
    end
  end

  if args[1][1] ~= "void" then
    local inode
    if old_state and old_state.ret then
      inode = i(insert, old_state.ret:get_text())
    else
      inode = i(insert)
    end

    vim.list_extend(nodes, {t({" * ", " * @return "}), inode, t({"", ""})})
    param_nodes.ret = inode
    insert = insert + 1
  end

  if vim.tbl_count(args[3]) ~= 1 then
    local exc = string.gsub(args[3][2], " throws ", "")
    local ins
    if old_state and old_state.ex then
      ins = i(insert, old_state.ex:get_text())
    else
      ins = i(insert)
    end
    vim.list_extend(nodes, {t({" * ", " * @throws " .. exc .. " "}), ins, t({"", ""})})
    param_nodes.ex = ins
    insert = insert + 1
  end

  vim.list_extend(nodes, {t({" */"})})

  local snip = sn(nil, nodes)
  -- Error on attempting overwrite.
  snip.old_state = param_nodes
  return snip
end

-- Make sure to not pass an invalid command, as io.popen() may write over nvim-text.
local function bash(_, _, command)
  local file = io.popen(command, "r")
  local res = {}
  for line in file:lines() do
    table.insert(res, line)
  end
  return res
end

-- Returns a snippet_node wrapped around an insert_node whose initial
-- text value is set to the current date in the desired format.
local date_input = function(args, state, fmt)
  local fmt = fmt or "%Y-%m-%d"
  return sn(nil, i(1, os.date(fmt)))
end

ls.snippets = {
  -- When trying to expand a snippet, luasnip first searches the tables for
  -- each filetype specified in 'filetype' followed by 'all'.
  -- If ie. the filetype is 'lua.c'
  --     - luasnip.lua
  --     - luasnip.c
  --     - luasnip.all
  -- are searched in that order.
  all = {
    -- Shorthand for repeating the text in a given node.
    s("repeat", {i(1, "text"), t({"", ""}), r(1)}),
    -- Directly insert the ouput from a function evaluated at runtime.
    s("part", p(os.date, "%Y")),
    -- Obviously, it's also possible to apply transformations, just like lambdas.
    s(
      "dl2",
      {
        i(1, "sample_text"),
        i(2, "sample_text_2"),
        t({"", ""}),
        dl(3, l._1:gsub("\n", " linebreak ") .. l._2, {1, 2})
      }
    ),
    -- Alternative printf-like notation for defining snippets. It uses format
    -- Empty placeholders are numbered automatically starting from 1 or the last
    -- value of a numbered placeholder. Named placeholders do not affect numbering.
    -- The delimiters can be changed from the default `{}` to something else.
    s("fmt4", fmt("foo() { return []; }", i(1, "x"), {delimiters = "[]"})),
    -- `fmta` is a convenient wrapper that uses `<>` instead of `{}`.
    s("fmt5", fmta("foo() { return <>; }", i(1, "x"))),
    -- By default all args must be used. Use strict=false to disable the check
    s("fmt6", fmt("use {} only", {t("this"), t("not this")}, {strict = false}))
  },
  tex = {
    -- rec_ls is self-referencing. That makes this snippet 'infinite' eg. have as many
    -- \item as necessary by utilizing a choiceNode.
    s(
      "ls",
      {
        t({"\\begin{itemize}", "\t\\item "}),
        i(1),
        d(2, rec_ls, {}),
        t({"", "\\end{itemize}"})
      }
    )
  },
  --     "prefix": "rfce",
  --     "body": "import { css } from '@emotion/core'\nimport React from 'react'\n\nexport const ${TM_FILENAME_BASE} = (props: {}) => {\n\treturn (\n\t\t<div css={css``}>\n\t\t\t$0\n\t\t</div>\n\t)\n}",
  --     "description": "Creates a React functional component with emotion import"
  typescriptreact = {
    s(
      "rfc",
      {
        t( "import React from 'react'"),
        t("export const ${TM_FILENAME_BASE} = (props : {}) => {"),
        t("return ("),
        t("\t\t<div>"),
        t("t$0"),
        t("t\t</div>"),
        t("\t)")
      }
    )
  }
}

-- autotriggered snippets have to be defined in a separate table, luasnip.autosnippets.
ls.autosnippets = {
  all = {
    s(
      "autotrigger",
      {
        t("autosnippet")
      }
    )
  }
}

-- in a lua file: search lua-, then c-, then all-snippets.
ls.filetype_extend("lua", {"c"})
-- in a cpp file: search c-snippets, then all-snippets only (no cpp-snippets!!).
ls.filetype_set("cpp", {"c"})

--[[
-- Beside defining your own snippets you can also load snippets from "vscode-like" packages
-- that expose snippets in json files, for example <https://github.com/rafamadriz/friendly-snippets>.
-- Mind that this will extend  `ls.snippets` so you need to do it after your own snippets or you
-- will need to extend the table yourself instead of setting a new one.
]]
--
--   "require": {
--     "prefix": "rq",
--     "body": "require('${1:module}')"
--   },
--
--  "const module = require('module')": {
--     "prefix": "cr",
--     "body": "const ${1:module} = require('${1:module}')"
--   },
--
-- "addEventListener": {
--     "prefix": "ae",
--     "body": "${1:document}.addEventListener('${2:event}', ${3:ev} => {\n\t${0}\n})"
--   },
--   "removeEventListener": {
--     "prefix": "rel",
--     "body": "${1:document}.removeEventListener('${2:event}', ${3:listener})"
--   },
--
--   "forEach loop": {
--     "prefix": "fe",
--     "body": "${1:iterable}.forEach((${2:item}) => {\n\t${0}\n})"
--   },
--   "map": {
--     "prefix": "map",
--     "body": "${1:iterable}.map((${2:item}) => {\n\t${0}\n})"
--   },
--
--
-- "reduce": {
--     "prefix": "reduce",
--     "body": "${1:iterable}.reduce((${2:previous}, ${3:current}) => {\n\t${0}\n}${4:, initial})"
--   },
--   "filter": {
--     "prefix": "filter",
--     "body": "${1:iterable}.filter((${2:item}) => {\n\t${0}\n})"
--   },
--   "find": {
--     "prefix": "find",
--     "body": "${1:iterable}.find((${2:item}) => {\n\t${0}\n})"
--   },
--   "every": {
--     "prefix": "every",
--     "body": "${1:iterable}.every((${2:item}) => {\n\t${0}\n})"
--   },
--   "some": {
--     "prefix": "some",
--     "body": "${1:iterable}.some((${2:item}) => {\n\t${0}\n})"
--   },
--
--
-- "var statement": {
--     "prefix": "v",
--     "body": "var ${1:name}"
--   },
--   "var assignment": {
--     "prefix": "va",
--     "body": "var ${1:name} = ${2:value}"
--   },
--   "let statement": {
--     "prefix": "l",
--     "body": "let ${1:name}"
--   },
--   "const statement": {
--     "prefix": "c",
--     "body": "const ${1:name}"
--   },
--   "const statement from destructuring": {
--     "prefix": "cd",
--     "body": "const { ${2:prop} } = ${1:value}"
--   },
--   "const statement from array destructuring": {
--     "prefix": "cad",
--     "body": "const [ ${2:prop} ] = ${1:value}"
--   },
--   "const assignment awaited": {
--     "prefix": "ca",
--     "body": "const ${1:name} = await ${2:value}"
--   },
--   "const destructuring assignment awaited": {
--     "prefix": "cda",
--     "body": "const { ${1:name} } = await ${2:value}"
--   },
--   "const arrow function assignment": {
--     "prefix": "cf",
--     "body": "const ${1:name} = (${2:arguments}) => {\n\treturn ${0}\n}"
--   },
--
--
--  "let assignment awaited": {
--     "prefix": "la",
--     "body": "let ${1:name} = await ${2:value}"
--   },
--
--
--   "const array": {
--     "prefix": "car",
--     "body": "const ${1:name} = [\n\t${0}\n]"
--   },
--
--
-- "module export": {
--     "prefix": "e",
--     "body": "export ${1:member}"
--   },
--   "module export const": {
--     "prefix": "ec",
--     "body": "export const ${1:member} = ${2:value}"
--   },
--
-- "export named function": {
--     "prefix": "ef",
--     "body": "export function ${1:member} (${2:arguments}) {\n\t${0}\n}"
--   },
--   "module default export": {
--     "prefix": "ed",
--     "body": "export default ${1:member}"
--   },
--   "module default export function": {
--     "prefix": "edf",
--     "body": "export default function ${1:name} (${2:arguments}) {\n\t${0}\n}"
--   },
--   "import module": {
--     "prefix": "im",
--     "body": "import ${2:*} from '${1:module}'"
--   },
--   "import module as": {
--     "prefix": "ia",
--     "body": "import ${2:*} as ${3:name} from '${1:module}'"
--   },
--   "import module destructured": {
--     "prefix": "id",
--     "body": "import {$2} from '${1:module}'"
--   },
--
--   "Array.isArray()": {
--     "prefix": "ia",
--     "body": "Array.isArray(${1:source})"
--   },
--
--   "throw new Error": {
--     "prefix": "tn",
--     "body": "throw new ${0:error}"
--   },
--   "try/catch": {
--     "prefix": "tc",
--     "body": "try {\n\t${0}\n} catch (${1:err}) {\n\t\n}"
--   },
--   "try/finally": {
--     "prefix": "tf",
--     "body": "try {\n\t${0}\n} finally {\n\t\n}"
--   },
--   "try/catch/finally": {
--     "prefix": "tcf",
--     "body": "try {\n\t${0}\n} catch (${1:err}) {\n\t\n} finally {\n\t\n}"
--   },
--
-- "Array.isArray()": {
--     "prefix": "ia",
--     "body": "Array.isArray(${1:source})"
--   },
--   "let and if statement": {
--     "prefix": "lif",
--     "body": "let ${0} \n if (${2:condition}) {\n\t${1}\n}"
--   },
--   "else statement": {
--     "prefix": "el",
--     "body": "lse {\n\t${0}\n}"
--   },
--   "else if statement": {
--     "prefix": "ei",
--     "body": "else if (${1:condition}) {\n\t${0}\n}"
--   },
--   "while iteration decrementing": {
--     "prefix": "wid",
--     "body": "let ${1:array}Index = ${1:array}.length\nwhile (${1:array}Index--) {\n\t${0}\n}"
--   },
--   "throw new Error": {
--     "prefix": "tn",
--     "body": "throw new ${0:error}"
--   },
--   "try/catch": {
--     "prefix": "tc",
--     "body": "try {\n\t${0}\n} catch (${1:err}) {\n\t\n}"
--   },
--   "try/finally": {
--     "prefix": "tf",
--     "body": "try {\n\t${0}\n} finally {\n\t\n}"
--   },
--   "try/catch/finally": {
--     "prefix": "tcf",
--     "body": "try {\n\t${0}\n} catch (${1:err}) {\n\t\n} finally {\n\t\n}"
--   },
--   "anonymous function": {
--     "prefix": "fan",
--     "body": "function (${1:arguments}) {${0}}"
--   },
--   "named function": {
--     "prefix": "fn",
--     "body": "function ${1:name} (${2:arguments}) {\n\t${0}\n}"
--   },
--   "async function": {
--     "prefix": "asf",
--     "body": "async function (${1:arguments}) {\n\t${0}\n}"
--   },
--   "async arrow function": {
--     "prefix": "aa",
--     "body": "async (${1:arguments}) => {\n\t${0}\n}"
--   },
--   "immediately-invoked function expression": {
--     "prefix": "iife",
--     "body": ";(function (${1:arguments}) {\n\t${0}\n})(${2})"
--   },
--   "async immediately-invoked function expression": {
--     "prefix": "aiife",
--     "body": ";(async (${1:arguments}) => {\n\t${0}\n})(${2})"
--   },
--   "arrow function": {
--     "prefix": "af",
--     "body": "(${1:arguments}) => ${2:statement}"
--   },
--   "arrow function with destructuring": {
--     "prefix": "fd",
--     "body": "({${1:arguments}}) => ${2:statement}"
--   },
--   "arrow function with destructuring returning destructured": {
--     "prefix": "fdr",
--     "body": "({${1:arguments}}) => ${1:arguments}"
--   },
--   "arrow function with body": {
--     "prefix": "f",
--     "body": "(${1:arguments}) => {\n\t${0}\n}"
--   },
--   "arrow function with return": {
--     "prefix": "fr",
--     "body": "(${1:arguments}) => {\n\treturn ${0}\n}"
--   },e
--
--   "console.log": {
--     "prefix": "cl",
--     "body": "console.log(${0})"
--   },
--   "console.log a variable": {
--     "prefix": "cv",
--     "body": "console.log('${0}:', ${0})"
--   },
--   "console.error": {
--     "prefix": "ce",
--     "body": "console.error(${0})"
--   },
--   "console.warn": {
--     "prefix": "cw",
--     "body": "console.warn(${0})"
--   },
--   "console.dir": {
--     "prefix": "cod",
--     "body": "console.dir('${0}:', ${0})"
--   },
--
-- "JSON.stringify()": {
--     "prefix": "js",
--     "body": "JSON.stringify($0)"
--   },
--   "JSON.parse()": {
--     "prefix": "jp",
--     "body": "JSON.parse($0)"
--   },
--   "method": {
--     "prefix": "m",
--     "body": "${1:method} (${2:arguments}) {\n\t${0}\n}"
--   },
--   "ternary": {
--     "prefix": "te",
--     "body": "${1:cond} ? ${2:true} : ${3:false}"
--   },
--   "ternary assignment": {
--     "prefix": "ta",
--     "body": "const ${0} = ${1:cond} ? ${2:true} : ${3:false}"
--   },
-- "return this": {
--     "prefix": "rt",
--     "body": "return ${0:this}"
--   },
--   "return null": {
--     "prefix": "rn",
--     "body": "return null"
--   },
--   "return new object": {
--     "prefix": "ro",
--     "body": "return {\n\t${0}\n}"
--   },
--   "return new array": {
--     "prefix": "ra",
--     "body": "return [\n\t${0}\n]"
--   },
--   "return promise": {
--     "prefix": "rp",
--     "body": "return new Promise((resolve, reject) => {\n\t${0}\n})"
--   },
--
-- "wrap selection in arrow function": {
--     "prefix": "wrap selection in arrow function",
--     "body": "() => {\n\t{$TM_SELECTED_TEXT}\n}",
--     "description": "wraps text in arrow function"
--   },
--   "wrap selection in async arrow function": {
--     "prefix": "wrap selection in async arrow function",
--     "body": "async () => {\n\t{$TM_SELECTED_TEXT}\n}",
--     "description": "wraps text in arrow function"
--   },
--
-- "For Loop": {
--     "prefix": "for",
--     "body": [
--       "for (let ${1:index} = 0; ${1:index} < ${2:array}.length; ${1:index}++) {",
--       "\tconst ${3:element} = ${2:array}[${1:index}];",
--       "\t$0",
--       "}"
--     ],
--     "description": "For Loop"
--   },
--   "For-Each Loop": {
--     "prefix": "foreach",
--     "body": ["${1:array}.forEach(${2:element} => {", "\t$0", "});"],
--     "description": "For-Each Loop"
--   },
--
--
--   "If Statement": {
--     "prefix": "if",
--     "body": ["if (${1:condition}) {", "\t$0", "}"],
--     "description": "If Statement"
--   },
--   "If-Else Statement": {
--     "prefix": "ifelse",
--     "body": ["if (${1:condition}) {", "\t$0", "} else {", "\t", "}"],
--     "description": "If-Else Statement"
--   },
--
--   "While Statement": {
--     "prefix": "while",
--     "body": ["while (${1:condition}) {", "\t$0", "}"],
--     "description": "While Statement"
--   },
--   "Do-While Statement": {
--     "prefix": "dowhile",
--     "body": ["do {", "\t$0", "} while (${1:condition});"],
--     "description": "Do-While Statement"
--   },
--
--   "Try-Catch Statement": {
--     "prefix": "trycatch",
--     "body": ["try {", "\t$0", "} catch (${1:error}) {", "\t", "}"],
--     "description": "Try-Catch Statement"
--   },
--   "Set Timeout Function": {
--     "prefix": "settimeout",
--     "body": ["setTimeout(() => {", "\t$0", "}, ${1:timeout});"],
--     "description": "Set Timeout Function"
--   },
--   "Set Interval Function": {
--     "prefix": "setinterval",
--     "body": ["setInterval(() => {", "\t$0", "}, ${1:interval});"],
--     "description": "Set Interval Function"
--   },
--   "Import external module.": {
--     "prefix": "import statement",
--     "body": ["import { $0 } from \"${1:module}\";"],
--     "description": "Import external module."
--   },
--
--   "Log warning to console": {
--     "prefix": "warn",
--     "body": ["console.warn($1);", "$0"],
--     "description": "Log warning to the console"
--   },
--   "Log error to console": {
--     "prefix": "error",
--     "body": ["console.error($1);", "$0"],
--     "description": "Log error to the console"
--   }

--   "reactClassCompoment": {
--     "prefix": "rcc",
--     "body": "import React, { Component } from 'react'\n\nclass ${TM_FILENAME_BASE} extends Component {\n\trender () {\n\t\treturn (\n\t\t\t<div>\n\t\t\t\t$0\n\t\t\t</div>\n\t\t)\n\t}\n}\n\nexport default ${1}",
--     "description": "Creates a React component class"
--   },
--
-- "reactFunctionComponent": {
--     "prefix": "rfc",
--     "body": "import React from 'react'\n\nexport const ${TM_FILENAME_BASE} = (props : {}) => {\n\treturn (\n\t\t<div>\n\t\t\t$0\n\t\t</div>\n\t)\n}",
--     "description": "Creates a React functional component without PropTypes"
--   },
--   "reactFunctionComponentWithEmotion": {
--     "prefix": "rfce",
--     "body": "import { css } from '@emotion/core'\nimport React from 'react'\n\nexport const ${TM_FILENAME_BASE} = (props: {}) => {\n\treturn (\n\t\t<div css={css``}>\n\t\t\t$0\n\t\t</div>\n\t)\n}",
--     "description": "Creates a React functional component with emotion import"
--   },
--
-- "jsx element": {
--     "prefix": "j",
--     "body": "<${1:elementName}>\n\t$0\n</${1}>",
--     "description": "an element"
--   },
--   "jsx element self closed": {
--     "prefix": "jc",
--     "body": "<${1:elementName} />",
--     "description": "an element self closed"
--   },
--   "jsx elements map": {
--     "prefix": "jm",
--     "body": "{${1:array}.map((item) => <${2:elementName} key={item.id}>\n\t$0\n</${2}>)}",
--     "description": "an element self closed"
--   },
--   "jsx elements map with return": {
--     "prefix": "jmr",
--     "body": "{${1:array}.map((item) => {\n\treturn <${2:elementName} key={item.id}>\n\t$0\n</${2}>\n})}",
--     "description": "an element self closed"
--   },
--   "jsx element wrap selection": {
--     "prefix": "jsx wrap selection with element",
--     "body": "<${1:elementName}>\n\t{$TM_SELECTED_TEXT}\n</${1}>",
--     "description": "an element"
--   },
--   "useState": {
--     "prefix": "us",
--     "body": "const [${0:val}, set${1:setterName}] = useState(${2:defVal})",
--     "description": "use state hook"
--   },
--   "useEffect": {
--     "prefix": "ue",
--     "body": ["useEffect(() => {", "\t$1", "}, [${3:dependencies}])$0"],
--     "description": "React useEffect() hook"
--   },
--   "useEffect with cleanup": {
--     "prefix": "uec",
--     "body": [
--       "useEffect(() => {",
--       "\t$1",
--       "\n\treturn () => {",
--       "\t\t$2",
--       "\t}",
--       "}, [${3:dependencies}])$0"
--     ],
--     "description": "React useEffect() hook with a cleanup function"
--   },
--   "createContext": {
--     "prefix": "cc",
--     "body": [
--       "export const $1 = createContext<$2>(",
--       "\t(null as any) as $2",
--       ")"
--     ],
--     "description": "creates a react context"
--   },
--   "useContext": {
--     "prefix": "uc",
--     "body": ["const $1 = useContext($2)$0"],
--     "description": "React useContext() hook"
--   },
--   "useRef": {
--     "prefix": "ur",
--     "body": ["const ${1:elName}El = useRef(null)$0"],
--     "description": "React useContext() hook"
--   },
--   "useCallback": {
--     "prefix": "ucb",
--     "body": [
--       "const ${1:memoizedCallback} = useCallback(",
--       "\t() => {",
--       "\t\t${2:doSomething}(${3:a}, ${4:b})",
--       "\t},",
--       "\t[${5:a}, ${6:b}],",
--       ")$0"
--     ],
--     "description": "React useCallback() hook"
--   },
--   "useMemo": {
--     "prefix": "ume",
--     "body": [
--       "const ${1:memoizedValue} = useMemo(() => ${2:computeExpensiveValue}(${3:a}, ${4:b}), [${5:a}, ${6:b}])$0"
--     ],
--     "description": "React useMemo() hook"
--   }
-- }
--
-- "reactFunctionComponent": {
--     "prefix": "rfc",
--     "body": "\nconst ${TM_FILENAME_BASE} = () => {\n\treturn (\n\t\t<div>\n\t\t\t$0\n\t\t</div>\n\t)\n}\n\nexport default ${TM_FILENAME_BASE}",
--     "description": "Creates a React function component without PropTypes"
--   },
--   "reactFunctionComponentWithCustomName": {
--     "prefix": "rfcn",
--     "body": "\nconst ${1:functionname} = () => {\n\treturn (\n\t\t<div>\n\t\t\t$0\n\t\t</div>\n\t)\n}\n\nexport default ${1:functionname}",
--     "description": "Creates a React function component with custom name"
--   },
--   "reactFunctionComponentWithEmotion": {
--     "prefix": "rfce",
--     "body": "import { css } from '@emotion/core'\n\nexport const ${TM_FILENAME_BASE} = () => {\n\treturn (\n\t\t<div css={css``}>\n\t\t\t$0\n\t\t</div>\n\t)\n}",
--     "description": "Creates a React functional component with emotion"
--   },
--
-- "jsx element": {
--     "prefix": "j",
--     "body": "<${1:elementName}>\n\t$0\n</${1}>",
--     "description": "an element"
--   },
--   "jsx element self closed": {
--     "prefix": "jc",
--     "body": "<${1:elementName} />",
--     "description": "an element self closed"
--   },
--   "jsx elements map": {
--     "prefix": "jm",
--     "body": "{${1:array}.map((item) => <${2:elementName} key={item.id}>\n\t$0\n</${2}>)}",
--     "description": "an element self closed"
--   },
--   "jsx elements map with return": {
--     "prefix": "jmr",
--     "body": "{${1:array}.map((item) => {\n\treturn <${2:elementName} key={item.id}>\n\t$0\n</${2}>\n})}",
--     "description": "an element self closed"
--   },
--   "jsx element wrap selection": {
--     "prefix": "jsx wrap selection with element",
--     "body": "<${1:elementName}>\n\t{$TM_SELECTED_TEXT}\n</${1}>",
--     "description": "an element"
--   },
--   "useState": {
--     "prefix": "us",
--     "body": "const [${1:setterName}, set${1:setterName}] = useState(${2:defVal})$0",
--     "description": "use state hook"
--   },
--   "useEffect": {
--     "prefix": "ue",
--     "body": [
--       "useEffect(() => {",
--       "\t$1",
--       "}, [${3:dependencies}])$0"
--     ],
--     "description": "React useEffect() hook"
--   },
--   "useEffect with return": {
--     "prefix": "uer",
--     "body": [
--       "useEffect(() => {",
--       "\t$1",
--       "\n\treturn () => {",
--       "\t\t$2",
--       "\t}",
--       "}, [${3:dependencies}])$0"
--     ],
--     "description": "React useEffect() hook with return statement"
--   },
--   "useContext": {
--     "prefix": "uc",
--     "body": ["const $1 = useContext($2)$0"],
--     "description": "React useContext() hook"
--   },
--   "useRef": {
--     "prefix": "ur",
--     "body": ["const ${1:elName}El = useRef(null)$0"],
--     "description": "React useContext() hook"
--   },
--   "useCallback": {
--     "prefix": "ucb",
--     "body": [
--       "const ${1:memoizedCallback} = useCallback(",
--       "\t() => {",
--       "\t\t${2:doSomething}(${3:a}, ${4:b})",
--       "\t},",
--       "\t[${5:a}, ${6:b}],",
--       ")$0"
--     ],
--     "description": "React useCallback() hook"
--   },
--   "useMemo": {
--     "prefix": "ume",
--     "body": [
--       "const ${1:memoizedValue} = useMemo(() => ${2:computeExpensiveValue}(${3:a}, ${4:b}), [${5:a}, ${6:b}])$0"
--     ],
--     "description": "React useMemo() hook"
--   }
-- }
--
-- 	"For Loop": {
-- 		"prefix": "for",
-- 		"body": [
-- 			"for (let ${1:index} = 0; ${1:index} < ${2:array}.length; ${1:index}++) {",
-- 			"\tconst ${3:element} = ${2:array}[${1:index}];",
-- 			"\t$0",
-- 			"}"
-- 		],
-- 		"description": "For Loop"
-- 	},
-- 	"For-Each Loop using =>": {
-- 		"prefix": "foreach =>",
-- 		"body": [
-- 			"${1:array}.forEach(${2:element} => {",
-- 			"\t$0",
-- 			"});"
-- 		],
-- 		"description": "For-Each Loop using =>"
-- 	},
-- 	"For-In Loop": {
-- 		"prefix": "forin",
-- 		"body": [
-- 			"for (const ${1:key} in ${2:object}) {",
-- 			"\tif (${2:object}.hasOwnProperty(${1:key})) {",
-- 			"\t\tconst ${3:element} = ${2:object}[${1:key}];",
-- 			"\t\t$0",
-- 			"\t}",
-- 			"}"
-- 		],
-- 		"description": "For-In Loop"
-- 	},
-- 	"For-Of Loop": {
-- 		"prefix": "forof",
-- 		"body": [
-- 			"for (const ${1:iterator} of ${2:object}) {",
-- 			"\t$0",
-- 			"}"
-- 		],
-- 		"description": "For-Of Loop"
-- 	},
-- 	"Function Statement": {
-- 		"prefix": "function",
-- 		"body": [
-- 			"function ${1:name}(${2:params}:${3:type}) {",
-- 			"\t$0",
-- 			"}"
-- 		],
-- 		"description": "Function Statement"
-- 	},
-- 	"If Statement": {
-- 		"prefix": "if",
-- 		"body": [
-- 			"if (${1:condition}) {",
-- 			"\t$0",
-- 			"}"
-- 		],
-- 		"description": "If Statement"
-- 	},
-- 	"If-Else Statement": {
-- 		"prefix": "ifelse",
-- 		"body": [
-- 			"if (${1:condition}) {",
-- 			"\t$0",
-- 			"} else {",
-- 			"\t",
-- 			"}"
-- 		],
-- 		"description": "If-Else Statement"
-- 	},
-- 	"New Statement": {
-- 		"prefix": "new",
-- 		"body": [
-- 			"const ${1:name} = new ${2:type}(${3:arguments});$0"
-- 		],
-- 		"description": "New Statement"
-- 	},
-- 	"Switch Statement": {
-- 		"prefix": "switch",
-- 		"body": [
-- 			"switch (${1:key}) {",
-- 			"\tcase ${2:value}:",
-- 			"\t\t$0",
-- 			"\t\tbreak;",
-- 			"",
-- 			"\tdefault:",
-- 			"\t\tbreak;",
-- 			"}"
-- 		],
-- 		"description": "Switch Statement"
-- 	},
-- 	"While Statement": {
-- 		"prefix": "while",
-- 		"body": [
-- 			"while (${1:condition}) {",
-- 			"\t$0",
-- 			"}"
-- 		],
-- 		"description": "While Statement"
-- 	},
-- 	"Do-While Statement": {
-- 		"prefix": "dowhile",
-- 		"body": [
-- 			"do {",
-- 			"\t$0",
-- 			"} while (${1:condition});"
-- 		],
-- 		"description": "Do-While Statement"
-- 	},
-- 	"Try-Catch Statement": {
-- 		"prefix": "trycatch",
-- 		"body": [
-- 			"try {",
-- 			"\t$0",
-- 			"} catch (${1:error}) {",
-- 			"\t",
-- 			"}"
-- 		],
-- 		"description": "Try-Catch Statement"
-- 	},
--
