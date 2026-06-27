local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local sn = ls.snippet_node
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep
local parse = require("luasnip.util.parser").parse_snippet

local function in_mathzone()
    if vim.fn.exists("*vimtex#syntax#in_mathzone") == 1 then
        return vim.fn["vimtex#syntax#in_mathzone"]() == 1
    end
    return false
end

local function outside_mathzone()
    return not in_mathzone()
end

local function ps(context, body, opts)
    context = vim.tbl_extend("force", context, opts or {})
    return parse(context, body)
end

local function autosnip(trig, body, cond, opts)
    return ps(vim.tbl_extend("force", {
        trig = trig,
        snippetType = "autosnippet",
        wordTrig = true,
    }, opts or {}), body, { condition = cond })
end

local function math_auto(trig, body, opts)
    return autosnip(trig, body, in_mathzone, opts)
end

local function text_auto(trig, body, opts)
    return autosnip(trig, body, outside_mathzone, opts)
end

local function reg_auto(trig, nodes, opts)
    opts = opts or {}
    opts.trig = trig
    opts.regTrig = true
    opts.snippetType = "autosnippet"
    opts.wordTrig = false
    return s(opts, nodes, { condition = opts.condition or in_mathzone })
end

local snippets = {
    s({ trig = "beg", name = "begin/end environment" }, fmta([[
\begin{<>}
    <>
\end{<>}
]], { i(1, "environment"), i(2), rep(1) })),

    s({ trig = "sec", name = "section with label" }, fmta([[
\section{<>}
\label{sec:<>}

<>
]], { i(1, "Title"), i(2, "label"), i(0) })),

    s({ trig = "eq", name = "equation" }, fmta([[
\begin{equation}
    <>
\end{equation}
]], { i(1) })),

    s({ trig = "fig", name = "figure" }, fmta([[
\begin{figure}[<>]
    \centering
    \includegraphics[width=<>	extwidth]{<>}
    \caption{<>}
    \label{fig:<>}
\end{figure}
]], { i(1, "htbp"), i(2, "0.8"), i(3, "path/to/image"), i(4, "Caption"), i(5, "label") })),

    s({ trig = "partial", name = "partial derivative" }, fmta("\\frac{ \\partial <> }{ \\partial <> }<>", {
        i(1), i(2, "x"), i(0),
    })),

    s({ trig = "dint", name = "definite integral" }, fmta("\\int_{<>}^{<>} <> \\, d<> <>", {
        i(1, "0"), i(2, "\\infty"), i(3), i(4, "x"), i(0),
    })),

    s({ trig = "int", name = "integral" }, fmta("\\int <> \\, d<> <>", {
        i(1), i(2, "x"), i(0),
    })),

    s({ trig = "bra", name = "bra" }, fmta("\\bra{<>} <>", { i(1), i(0) })),
    s({ trig = "ket", name = "ket" }, fmta("\\ket{<>} <>", { i(1), i(0) })),
    s({ trig = "brk", name = "braket" }, fmta("\\braket{ <> | <> } <>", { i(1), i(2), i(0) })),
    s({ trig = "kbr", name = "ket-bra" }, fmta("\\ket{<>}\\bra{<>} <>", { i(1), i(2), i(0) })),

    s({ trig = "mat", name = "matrix environment" }, fmta([[
\begin{<>}
<>
\end{<>}
]], { c(1, {
        t("pmatrix"),
        t("bmatrix"),
        t("Bmatrix"),
        t("vmatrix"),
        t("Vmatrix"),
        t("matrix"),
    }), i(2), rep(1) })),
}

local autosnippets = {
    -- Text-mode math wrappers, migrated from Obsidian mk/dm.
    text_auto("mk", "$\\large $0$", { name = "inline math" }),
    text_auto("dm", "$$\\large\n$0\n$$", { name = "display math" }),
    text_auto("dhm", "$$\\huge\n$0\n$$", { name = "display huge math" }),

    -- Basic symbols and operators from Snippets.js.
    math_auto("ff", "\\frac{$1}{$2}$0", { name = "fraction" }),
    math_auto("//", "\\frac{$1}{$2}$0", { name = "fraction" }),
    math_auto("sq", "\\sqrt{ $1 }$0", { name = "sqrt" }),
    math_auto("sr", "^{2}", { name = "square" }),
    math_auto("cb", "^{3}", { name = "cube" }),
    math_auto("rd", "^{$1}$0", { name = "superscript" }),
    math_auto("sts", "_\\text{$1}$0", { name = "text subscript" }),
    math_auto("conj", "^{*}", { name = "complex conjugate" }),
    math_auto("dag", "^{\\dagger}", { name = "dagger" }),
    math_auto("rm", "\\mathrm{$1}$0", { name = "mathrm" }),
    math_auto("bf", "\\mathbf{$1}$0", { name = "mathbf" }),
    math_auto("cal", "\\mathcal{$1}$0", { name = "mathcal" }),
    math_auto("mbb", "\\mathbb{$1}$0", { name = "mathbb" }),
    math_auto("mcal", "\\mathcal{$1}$0", { name = "mathcal" }),
    math_auto("te", "\\text{$1}$0", { name = "text" }),
    math_auto("text", "\\text{$1}$0", { name = "text" }),

    math_auto("sum", "\\sum\\limits_{$1}^{$2}$0", { name = "sum" }),
    math_auto("prod", "\\prod\\limits_{$1}^{$2}$0", { name = "product" }),
    math_auto("oprod", "\\bigotimes\\limits_{$1}^{$2}$0", { name = "tensor product" }),
    math_auto("lim", "\\lim_{ ${1:n} \\to ${2:\\infty} } $0", { name = "limit" }),
    math_auto("eval", "\\bigg|_{${1:-\\infty}}^{${2:\\infty}}$0", { name = "evaluation bar" }),
    math_auto("def=", " \\triangleq ", { name = "defined equals" }),

    math_auto("oinf", "\\int_{0}^{\\infty} $1 \\, d${2:x} $0", { name = "0 to infinity integral" }),
    math_auto("infi", "\\int_{-\\infty}^{\\infty} $1 \\, d${2:x} $0", { name = "infinite integral" }),
    math_auto("oint", "\\oint", { name = "closed integral" }),
    math_auto("iint", "\\iint", { name = "double integral" }),
    math_auto("iiint", "\\iiint", { name = "triple integral" }),

    -- Greek letters from Snippets.js.
    math_auto("@a", "\\alpha", { name = "alpha" }),
    math_auto("@A", "\\alpha", { name = "alpha" }),
    math_auto("@b", "\\beta", { name = "beta" }),
    math_auto("@B", "\\beta", { name = "beta" }),
    math_auto("@c", "\\chi", { name = "chi" }),
    math_auto("@C", "\\chi", { name = "chi" }),
    math_auto("@g", "\\gamma", { name = "gamma" }),
    math_auto("@G", "\\Gamma", { name = "Gamma" }),
    math_auto("@d", "\\delta", { name = "delta" }),
    math_auto("@D", "\\Delta", { name = "Delta" }),
    math_auto("@e", "\\epsilon", { name = "epsilon" }),
    math_auto(":e", "\\varepsilon", { name = "varepsilon" }),
    math_auto("@z", "\\zeta", { name = "zeta" }),
    math_auto("@t", "\\theta", { name = "theta" }),
    math_auto("@T", "\\Theta", { name = "Theta" }),
    math_auto("@k", "\\kappa", { name = "kappa" }),
    math_auto("@l", "\\lambda", { name = "lambda" }),
    math_auto("@L", "\\Lambda", { name = "Lambda" }),
    math_auto("@m", "\\mu", { name = "mu" }),
    math_auto("@r", "\\rho", { name = "rho" }),
    math_auto("@s", "\\sigma", { name = "sigma" }),
    math_auto("@S", "\\Sigma", { name = "Sigma" }),
    math_auto("ome", "\\omega", { name = "omega" }),
    math_auto("@o", "\\omega", { name = "omega" }),
    math_auto("@O", "\\Omega", { name = "Omega" }),

    -- Common math constants and sets.
    math_auto("ooo", "\\infty", { name = "infinity" }),
    math_auto("CC", "\\mathbb{C}", { name = "complex numbers" }),
    math_auto("RR", "\\mathbb{R}", { name = "real numbers" }),
    math_auto("ZZ", "\\mathbb{Z}", { name = "integers" }),
    math_auto("NN", "\\mathbb{N}", { name = "natural numbers" }),
    math_auto("II", "\\mathbb{1}", { name = "identity" }),
    math_auto("LL", "\\mathcal{L}", { name = "lagrangian/L" }),
    math_auto("AA", "\\mathcal{A}", { name = "mathcal A" }),
    math_auto("ell", "\\ell", { name = "ell" }),

    -- Relations and arrows.
    math_auto("+-", "\\pm", { name = "plus-minus" }),
    math_auto("-+", "\\mp", { name = "minus-plus" }),
    math_auto("...", "\\dots", { name = "dots" }),
    math_auto("<->", "\\leftrightarrow ", { name = "leftrightarrow" }),
    math_auto("->", "\\to", { name = "to" }),
    math_auto("!>", "\\mapsto", { name = "mapsto" }),
    math_auto("=>", "\\implies", { name = "implies" }),
    math_auto("=<", "\\impliedby", { name = "implied by" }),
    math_auto("iff", "\\iff", { name = "iff" }),
    math_auto("===", "\\equiv", { name = "equiv" }),
    math_auto("!=", "\\neq", { name = "not equal" }),
    math_auto(">=", "\\geq", { name = "greater equal" }),
    math_auto("<=", "\\leq", { name = "less equal" }),
    math_auto(">>", "\\gg", { name = "much greater" }),
    math_auto("<<", "\\ll", { name = "much less" }),
    math_auto("~~", "\\sim", { name = "similar" }),
    math_auto("prop", "\\propto", { name = "propto" }),
    math_auto("xx", "\\times", { name = "times" }),
    math_auto("**", "\\cdot", { name = "cdot" }),
    math_auto("para", "\\parallel", { name = "parallel" }),
    math_auto("inn", "\\in", { name = "in" }),
    math_auto("notin", "\\not\\in", { name = "not in" }),
    math_auto("eset", "\\emptyset", { name = "empty set" }),
    math_auto("and", "\\cap", { name = "cap" }),
    math_auto("orr", "\\cup", { name = "cup" }),

    -- Vector calculus and physics.
    math_auto("nabla", "\\nabla", { name = "nabla" }),
    math_auto("del", "\\nabla", { name = "nabla" }),
    math_auto("curl", "\\nabla \\times ", { name = "curl" }),
    math_auto("div", "\\nabla \\cdot ", { name = "divergence" }),
    math_auto("grad", "\\nabla", { name = "gradient" }),
    math_auto("hba", "\\hbar", { name = "hbar" }),
    math_auto("kbt", "k_{B}T", { name = "kBT" }),
    math_auto("o+", "\\oplus ", { name = "oplus" }),
    math_auto("ox", "\\otimes ", { name = "otimes" }),

    -- Brackets and environments.
    math_auto("avg", "\\langle $1 \\rangle $0", { name = "angle brackets" }),
    math_auto("norm", "\\lvert $1 \\rvert $0", { name = "norm" }),
    math_auto("Norm", "\\lVert $1 \\rVert $0", { name = "Norm" }),
    math_auto("ceil", "\\lceil $1 \\rceil $0", { name = "ceil" }),
    math_auto("floor", "\\lfloor $1 \\rfloor $0", { name = "floor" }),
    math_auto("lr(", "\\left( $1 \\right) $0", { name = "left/right parentheses" }),
    math_auto("lr|", "\\left| $1 \\right| $0", { name = "left/right bars" }),
    math_auto("lr{", "\\left\\{ $1 \\right\\} $0", { name = "left/right braces" }),
    math_auto("lr[", "\\left[ $1 \\right] $0", { name = "left/right brackets" }),
    math_auto("align", "\\begin{align*}\n$1\n\\end{align*}", { name = "align environment" }),
    math_auto("case", "\\begin{cases}\n$1\n\\end{cases}", { name = "cases" }),
    math_auto("pmat", "\\begin{pmatrix}\n$1\n\\end{pmatrix}", { name = "pmatrix" }),
    math_auto("bmat", "\\begin{bmatrix}\n$1\n\\end{bmatrix}", { name = "bmatrix" }),

    -- Regex snippets that are safe and high-value.
    reg_auto("([A-Za-z])(\\d)", {
        f(function(_, snip)
            return snip.captures[1] .. "_{" .. snip.captures[2] .. "}"
        end),
    }, { name = "letter digit subscript", condition = in_mathzone }),

    reg_auto("([a-zA-Z])hat", {
        f(function(_, snip)
            return "\\hat{" .. snip.captures[1] .. "}"
        end),
    }, { name = "letter hat", condition = in_mathzone }),

    reg_auto("([a-zA-Z])bar", {
        f(function(_, snip)
            return "\\bar{" .. snip.captures[1] .. "}"
        end),
    }, { name = "letter bar", condition = in_mathzone }),

    reg_auto("([a-zA-Z])dot", {
        f(function(_, snip)
            return "\\dot{" .. snip.captures[1] .. "}"
        end),
    }, { name = "letter dot", condition = in_mathzone }),

    reg_auto("([a-zA-Z])vec", {
        f(function(_, snip)
            return "\\vec{" .. snip.captures[1] .. "}"
        end),
    }, { name = "letter vector", condition = in_mathzone }),
}

return snippets, autosnippets
