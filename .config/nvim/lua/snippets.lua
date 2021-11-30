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
local sn = ls.snippet_node
local isn = ls.indent_snippet_node

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

local js_thing = {
  s("rq", {t("require('"), i(1, "module"), t("')")}),
  s("cr", {t("const "), i(1), t(" require('"), i(2), t("')")}),
  s(
    "fe",
    {
      i(1),
      t(".fotEach(("),
      i(2),
      t({") => {", "\t"}),
      i(3),
      t({"", "})"})
    }
  ),
  s(
    "map",
    {
      i(1),
      t(".map(("),
      i(2),
      t({") => {", "\t"}),
      i(3),
      t({"", "})"})
    }
  ),
  s(
    "filter",
    {
      i(1),
      t(".filter(("),
      i(2),
      t({") => {", "\t"}),
      i(3),
      t({"", "})"})
    }
  ),
  s(
    "find",
    {
      i(1),
      t(".find(("),
      i(2),
      t({") => {", "\t"}),
      i(3),
      t({"", "})"})
    }
  ),
  s(
    "every",
    {
      i(1),
      t(".every(("),
      i(2),
      t({") => {", "\t"}),
      i(3),
      t({"", "})"})
    }
  ),
  s(
    "some",
    {
      i(1),
      t(".some(("),
      i(2),
      t({") => {", "\t"}),
      i(3),
      t({"", "})"})
    }
  ),
  s("v", {t("var "), i(1, "name"), t(" = "), i(2)}),
  s("va", {t("var "), i(1, "name"), t(" = "), i(2)}),
  s("l", {t("let "), i(1, "name")}),
  s("c", {t("cosnt "), i(1, "name"), t(" = "), i(2)}),
  s("cd", {t("cosnt { "), i(1, "name"), t(" } = "), i(2)}),
  s("cad", {t("cosnt { "), i(1, "name"), t(" } = "), i(2)}),
  s(
    "caf",
    {
      t("cosnt "),
      i(1, "name"),
      t(" = ( "),
      i(2),
      t({" ) => {", "\t return "}),
      i(0),
      t({"", "}"})
    }
  ),
  s("la", {t("let "), i(1, "name"), t(" = await "), i(2)}),
  s("car", {t("const "), i(1, "name"), t({" = [ ", "\t"}), i(2), t({"", "]"})}),
  s("e", {t("export "), i(1, "name")}),
  s("ec", {t("export  const "), i(1, "name"), t(" = "), i(2)}),
  -- s("ef", {t("export  const "), i(1, "name"), t(" = "), i(2)}),

  s("im", {t("import "), i(2, "name"), t(" from '"), i(1), t("'")}),
  s("ia", {t("import "), i(2, "name"), t(" as "), i(3), t(" from '"), i(1), t("'")}),
  s("id", {t("import { "), i(2), t(" } from '"), i(1), t("'")}),
  s("te", {t("throw new"), i(2), t(" } from '"), i(1), t("'")}),
  s("tc", {t({"try {", "\t"}), i(1), t({"", "} catch ("}), i(2), t({") {", "\t"}), i(3), t({"", "}"})}),
  --     "body": "try {\n\t${0}\n} finally {\n\t\n}"
  --     "body": "try {\n\t${0}\n} catch (${1:err}) {\n\t\n} finally {\n\t\n}"

  s(
    "if",
    {
      t("if ( "),
      i(1),
      t({" ) {", "\t"}),
      i(2),
      t({"", "}"})
    }
  ),
  s(
    "el",
    {
      t({"else { ", "\t"}),
      i(1),
      t({"", "}"})
    }
  ),
  s(
    "ei",
    {
      t({"else if ( "}),
      i(1),
      t({") { ", "\t"}),
      i(2),
      t({"", "}"})
    }
  ),
  --     "body": "try {\n\t${0}\n} catch (${1:err}) {\n\t\n} finally {\n\t\n}"
  --     "body": "try {\n\t${0}\n} finally {\n\t\n}"
  --
  s(
    "fn",
    {
      t({"function "}),
      i(1, "name"),
      t({" ( "}),
      i(2),
      t({" ) {", "\t"}),
      i(3),
      t({"", "}"})
    }
  ),
  s(
    "asf",
    {
      t({"async function "}),
      i(1, "name"),
      t({" ( "}),
      i(2),
      t({" ) {", "\t"}),
      i(3),
      t({"", "}"})
    }
  ),
  s(
    "aa",
    {
      t({"async ( "}),
      i(1, "arguments"),
      t({" ) => {", "\t"}),
      i(2),
      t({"", "}"})
    }
  ),
  s("cl", {t("console.log("), i(1), t(")")}),
  s("js", {t("JSON.stringify("), i(1), t(")")}),
  s("jp", {t("JSON.parse("), i(1), t(")")}),
  s("te", {i(1, "cond"), t(" ? "), i(2, "true"), t(" : "), i(3, "false")}),
  s("ta", {t("const = "), i(1, "cond"), t(" ? "), i(2, "true"), t(" : "), i(3, "false")}),
  s("rt", {t("return "), i(2)}),
  s("rn", {t("return  null")}),
  s("ro", {t("return { "), i(1), t(" }")}),
  s("ra", {t("return [ "), i(1), t(" ]")})
}

ls.snippets = {
  all = {
    s(
      "isn",
      {
        isn(
          1,
          {
            t(
              {
                "This is indented as deep as the trigger",
                "and this is at the beginning of the next line"
              }
            )
          },
          ""
        )
      }
    )

    -- s("trig", c(1, {
    -- 	t("Ugh boring, a text node"),
    -- 	i(nil, "At least I can edit something now..."),
    -- 	f(function(args) return "Still only counts as text!!" end, {})
    -- }))
    -- s("trigger", i(1, "This text is SELECTed after expanding the snippet.")),

    -- s("trig", {
    -- 	i(1),
    -- 	f(function(args, snip, user_arg_1) return args[1][1] .. user_arg_1 end,
    -- 		{1},
    -- 		"Will be appended to text from i(0)"),
    -- 	i(0)
    -- })

    -- s("trigger", {
    -- 	t({"", "After expanding, the cursor is here ->"}), i(1),
    -- 	t({"After jumping forward once, cursor is here ->"}), i(2),
    -- 	t({"", "After jumping once more, the snippet is exited there ->"}), i(0),
    -- })
    -- s("trigger", t({"Wow! Text!", "And another line."}))
  },
  javascript = js_thing,
  typescript = js_thing,
  javascriptreact = js_thing,
  typescriptreact = js_thing,
  svelte = js_thing,
  tex = {}
}

ls.autosnippets = {
  all = {}
}

-- in a lua file: search lua-, then c-, then all-snippets.
ls.filetype_extend("lua", {"c"})
-- in a cpp file: search c-snippets, then all-snippets only (no cpp-snippets!!).
ls.filetype_set("cpp", {"c"})

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
