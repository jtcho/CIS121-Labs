
% cislab.cls
% ----------
% Custom LaTeX class file template for all lab-related
% material.
% 
% Author: JT Cho (jonathan.t.cho@gmail.com)
% Painstakingly written by hand because web editors
% are for chumps.

% Documents must be compiled using:
%   xelatex --shell-escape [filename].tex

% Introduces various new commands for convenience:
% See command definition for documentation.
% \Mod
% \ceil
% \floor
% \labtitle
% \includemodule

\ProvidesClass{cis121}[2015/07/07 Data Structures and Algorithms]
% Require XeLaTeX for Minted package.
\NeedsTeXFormat{LaTeX2e}

% Read all documentclass options and check for *.min for options.
% if no such file exists pass to the article class.
\DeclareOption*{\InputIfFileExists{\CurrentOption.min}{}{%
    \PassOptionsToClass{\CurrentOption}{article}}}
% Execute options processing.
\ProcessOptions \relax

% Inherit from article.
\LoadClass{article}

% Page Layout
\RequirePackage[verbose, lmargin=1in, rmargin=1in, tmargin=1in, bmargin=1in]{geometry}
\RequirePackage{amsmath, amsfonts, amsthm, amssymb}
\RequirePackage{enumerate, mathtools}
\RequirePackage{algorithm, algorithmicx, algpseudocode}
\RequirePackage{hyperref}
\RequirePackage{framed, graphics, placeins, caption}
\RequirePackage{tikz}
\RequirePackage{titlesec}
\RequirePackage[skins]{tcolorbox}
\tcbuselibrary{minted}

% Uniform font loading.
\RequirePackage{fontspec}
% Fancy language-specific code blocks.
\RequirePackage{minted}         
% Allows use of \uline for underlining while preserving \em, \emph.
\RequirePackage[normalem]{ulem}

% Load all images from "images/".
\graphicspath{{images/}}

\setsansfont{Calibri}       % 
\setmonofont{Consolas}      % 

% Remove `End`-statements from Algorithm environment.
\algtext*{EndWhile}
\algtext*{EndIf}
\algtext*{EndFor}
\algtext*{EndFunction}

% Styling for Minted Code Prettifying.
\definecolor{bg}{rgb}{0.9804,0.98,0.90196}
\renewcommand{\theFancyVerbLine}{
    \sffamily\textcolor[rgb]{0.5,0.5,0.5}{\scriptsize\arabic{FancyVerbLine}}}

% Sections will have a hrule (horizontal underline) spanning
% the text-width underneath them.
\titleformat{\section}{\normalfont\Large\bfseries}{\thesection}{1em}{}[{\titlerule[0.6pt]}]


% Recitation Title
% Usage: \labtitle{[season] [yyyy]}{[lab_no]}{[days]}
\newcommand{\labtitle}[3]{
    \framebox{\framebox{
        \begin{minipage}[t]{0.9\columnwidth}
            \begin{center}
                \large\textbf{CIS 121---Data Structures and Algorithms with Java - #1}
            \par
            \end{center}
        \end{minipage}
    }}
    \begin{center}
        \textbf{Lab #2} --- #3
    \par\end{center}
}

% Usage: $$a \mod{b}$$
\newcommand{\Mod}[1]{\ \text{mod}\ #1}
% Usage: \ceil{x/2}
\DeclarePairedDelimiter\ceil{\lceil}{\rceil}
% Usage: \floor{x/2}
\DeclarePairedDelimiter\floor{\lfloor}{\rfloor}

% Shorthand command for including a specific module
% partial.
\newcommand{\includemodule}[1]{
    \input{modules/#1/partial}
    \newpage
}

% Shorthand environment for code block.
% Uses the `minted` environment and the tcolorbox
% package.
% Usage: \begin{code}{c} %... \end{code}
%
% \begin{minted}[ linenos,framesep=5mm,fontsize=\footnotesize,bgcolor=bg,mathescape]{[language]}
% \end{minted}
\newtcblisting{code}[1]{
    listing only,
    frame hidden,
    boxrule=0pt,
    minted options={
        linenos,
        framesep=5mm,
        fontsize=\footnotesize,
        bgcolor=bg,
        mathescape
    },
    colback=white,
    colframe=white,
    minted language=#1
}


% Shorthand environment for Java code block.
% Uses the `minted` environment and the tcolorbox
% package.
% Usage: \begin{java} %... \end{java}
%
% \begin{minted}[ linenos,framesep=5mm,fontsize=\footnotesize,bgcolor=bg,mathescape]{java}
% \end{minted}
\newtcblisting{java}{
    listing only,
    frame hidden,
    boxrule=0pt,
    minted options={
        linenos,
        framesep=5mm,
        fontsize=\footnotesize,
        bgcolor=bg,
        mathescape
    },
    colback=white,
    colframe=white,
    minted language=java
}
