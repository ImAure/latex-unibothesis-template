\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{unibothesis}[2026/10/06 v1.0 Class for thesis and reports]

%% --- Language selection ---
\DeclareOption{italian}{\AtBeginDocument{\selectlanguage{italian}}}
\DeclareOption{english}{\AtBeginDocument{\selectlanguage{english}}}

%% --- Thesis type selection ---
%%  options are:
%%      thesis, phd, lab, csb
%%  defaults to thesis
\newcommand{\@thesis@type}{thesis}

\DeclareOption{thesis}{\renewcommand{\@thesis@type}{thesis}}
\DeclareOption{phd}{\renewcommand{\@thesis@type}{phd}}
\DeclareOption{lab}{\renewcommand{\@thesis@type}{lab}}
\DeclareOption{csb}{\renewcommand{\@thesis@type}{csb}}

% Unknown options are passed to memoir class
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{memoir}}
\ProcessOptions\relax

% --- Class and basic preamble --- 
\LoadClass[a4paper]{memoir}

\RequirePackage[utf8]{inputenc}
\RequirePackage[T1]{fontenc}
\RequirePackage{geometry}
\RequirePackage{graphicx}
\RequirePackage{xifthen}
\RequirePackage{environ}
\RequirePackage{etoolbox}

\graphicspath{{./src/assets/images/}}

%% --- Private settable variables ---
% \def\@university{Alma Mater Studiorum -- University of Bologna}
\def\@department  {\@latex@error{No department given}{Try setting your department with \noexpand \department{Name of your department} in the preamble.}}
\def\@degree      {\@latex@error{No degree given}{Set degree with \noexpand\degree{your degree} in the preamble.}}
\def\@academicyear{\@latex@error{No academic year given}{Set academic year with \noexpand\academicyear{YYYY--YYYY}.}}
\def\@flavourtext {\@latex@error{No flavourtext provided}{Set flavour text with \noexpand\flavourtext{e.g. Master Degree Thesis in Physics...}}}

%% --- Language sensitive names ---
\def\@thesistype{}
\def\@academicyearname{}
\def\@honor{}

\providecommand*{\department}  [1]{\def\@department{#1}}
\providecommand*{\degree}      [1]{\def\@degree{#1}}
\providecommand*{\academicyear}[1]{\def\@academicyear{#1}}
\providecommand*{\flavourtext} [1]{\def\@flavourtext{#1}}

%% Lists for multiple names
\def\@candidatename{}
\def\@supervisorname{}
\def\@cosupervisorname{}
\def\@examinername{}

\newcommand*{\@candidates}{}
\newcommand*{\@supervisors}{}
\newcommand*{\@cosupervisors}{}
\newcommand*{\@examiners}{}

\newcounter{candidateno}
\newcounter{supervisorno}
\newcounter{cosupervisorno}
\newcounter{examinerno}

\setcounter{candidateno}{0}
\setcounter{supervisorno}{0}
\setcounter{cosupervisorno}{0}
\setcounter{examinerno}{0}

\NewDocumentCommand{\candidate}{O{} O{} m}{%
  \stepcounter{candidateno}
  \ifthenelse{\equal{#2}{}}
    {\gappto{\@candidates}{ \> #1 #3 \\}}
    {\gappto{\@candidates}{#1 \> #2 #3 \\}}
}
\NewDocumentCommand{\supervisor}{O{} O{} m}{%
  \stepcounter{supervisorno}
  \ifthenelse{\equal{#2}{}}
    {\gappto{\@supervisors}{ \> #1 #3 \\ }}
    {\gappto{\@supervisors}{#1 \> #2 #3 \\}}
}
\NewDocumentCommand{\cosupervisor}{O{} O{} m}{%
  \stepcounter{cosupervisorno}
  \ifthenelse{\equal{#2}{}}
    {\gappto{\@cosupervisors}{ \> #1 #3 \\}}
    {\gappto{\@cosupervisors}{#1 \> #2 #3 \\}}
}
\NewDocumentCommand{\examiner}{O{} O{} m}{%
  \stepcounter{examinerno}
  \ifthenelse{\equal{#2}{}}
    {\gappto{\@examiners}{ \> #1 #3 \\}}
    {\gappto{\@examiners}{#1 \> #2 #3 \\}}
}
\renewcommand{\title}[1]{\def\@title{#1}}

\newcommand{\@countcandidate}[1]{\stepcounter{candidateno}}
\newcommand{\@countsupervisor}[1]{\stepcounter{supervisorno}}
\newcommand{\@countcosupervisor}[1]{\stepcounter{cosupervisorno}}
\newcommand{\@countexaminer}[1]{\stepcounter{examinerno}}
\InputIfFileExists{./unibothesis-\@thesis@type.def}{}{%
  \@latex@error{Layout file unibothesis-\@thesis@type.def not found}{Ask a friend...}%
}


% --- Memoir base page layout ---
\settypeblocksize{*}{1.2\lxvchars}{*} % fixed best width based on font size
\setlrmargins{*}{*}{1}                % {left}{right}{ratio} (1:1)
\setulmarginsandblock{1.5in}{*}{1.4}  % {upper}{lower}{ratio} (1.5:1.4*1.5)
\checkandfixthelayout                 % does the magic


% --- Headers and pagestyle ---
\setlength{\headwidth}{\textwidth}

\makepagestyle{thesis}
\makerunningwidth{thesis}{\headwidth}
\makeheadrule{thesis}{\headwidth}{\normalrulethickness}
\makeheadposition{thesis}{flushright}{flushleft}{flushright}{flushleft}
\makepsmarks{thesis}{%
    \nouppercaseheads
    \createmark{chapter}{both}{shownumber}{\chaptername\ }{.\ }
    \createmark{section}{right}{shownumber}{}{.\ }
    \createplainmark{toc}{both}{\contentsname}
    \createplainmark{lof}{both}{\listfigurename}
    \createplainmark{lot}{both}{\listtablename}
    \createplainmark{bib}{both}{\bibname}
    \createplainmark{index}{both}{\indexname}
    \createplainmark{glossary}{both}{\glossaryname}
}
\makepagestyle{append}
\makerunningwidth{append}{\headwidth}
\makeheadrule{append}{\headwidth}{\normalrulethickness}
\makeheadposition{append}{flushright}{flushleft}{flushright}{flushleft}
\makepsmarks{append}{%
    \nouppercaseheads
    \createmark{chapter}{both}{shownumber}{\appendixname\ }{.\ }
    \createmark{section}{right}{shownumber}{}{.\ }
    \createplainmark{toc}{both}{\contentsname}
    \createplainmark{lof}{both}{\listfigurename}
    \createplainmark{lot}{both}{\listtablename}
    \createplainmark{bib}{both}{\bibname}
    \createplainmark{index}{both}{\indexname}
    \createplainmark{glossary}{both}{\glossaryname}
}

\if@twoside
  \makeoddhead{thesis}{\bfseries\rightmark}{}{\bfseries\thepage}
  \makeevenhead{thesis}{\bfseries\thepage}{}{\bfseries\leftmark}
  \makeoddhead{append}{\bfseries\rightmark}{}{\bfseries\thepage}
  \makeevenhead{append}{\bfseries\thepage}{}{\bfseries\leftmark}
\else
  \makeoddhead{thesis}{\bfseries\leftmark}{}{\bfseries\thepage}
  \makeoddhead{append}{\bfseries\leftmark}{}{\bfseries\thepage}
\fi

%\chapterstyle{hangnum}
\aliaspagestyle{chapter}{empty} % toglie il numero di pagina nelle pagine con il nome del capitolo.
\aliaspagestyle{part}{empty}

\setsecnumdepth{subsection}
