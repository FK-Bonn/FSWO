%%
%% IDENTIFICATION
%%
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{fswo}[2020-11-04 Klasse zur Setzung von Ordnungen und Satzungen, angepasst an die Fachschaftswahlordnung Bonn]

%%
%% OPTIONS
%%

% Allows Key-Value Options
\RequirePackage{kvoptions}

\SetupKeyvalOptions{
    family=FK,
    prefix=FK@
}

% use option pair draft/final
\DeclareBoolOption{draft}
\DeclareComplementaryOption{final}{draft}

\DeclareStringOption[Abschnitt]{sectionprefix}

\DeclareBoolOption{multilinesections}

% default values for the document class
\DeclareStringOption[12]{DIV}
\DeclareStringOption[half]{parskip}
\DeclareStringOption[10pt]{fontsize}

% pass all other options to the document class
\DeclareDefaultOption{\PassOptionsToClass{\CurrentOption}{scrartcl}}

% process all options
\ProcessKeyvalOptions*

% pass default values to the document class
\PassOptionsToClass{DIV=\FK@DIV}{scrartcl}
\PassOptionsToClass{parskip=\FK@parskip}{scrartcl}
\PassOptionsToClass{fontsize=\FK@fontsize}{scrartcl}

%%
%% LOADING PACKAGES
%%

% load the class "scrartcl" from the KoMa-Script bundle
\LoadClass[%
    a4paper%
    ]{scrartcl}


% include the following packages if one is not using lualatex but pdftex instead
% ToDo: Load these automatically if needed
%\usepackage[utf8]{inputenc}	% Input-Encoding
%\RequirePackage[T1]{fontenc}   % Font-Encoding
%\RequirePackage{lmodern}       % LModern font
%\RequirePackage{textcomp}      % Improved § Symbol

\RequirePackage[ngerman]{babel} % deutsche Lokalisierung
\RequirePackage{mathtools}      % Standard Mathebefehle, lädt amsmath
\RequirePackage{graphicx}       % Einbindung von Bildern
\RequirePackage{microtype}      % improved micro-typography: character protrusion and font expansion are enabled by default.

\RequirePackage{etoolbox}       %
\RequirePackage{lineno}         % Nummerierung der Zeilen
\RequirePackage{csquotes}       % bessere Anführungszeichen
\RequirePackage[%               % Euro-Zeichen setzen
official%                       %     %Felix: Argument war Teil des Ursprungspakets, mir ist unklar, was es tut
]{eurosym}                      %

%\RequirePackage[%               % Unter- und Durchstreichen von Text-Passagen. Meist redundant mit soul
%    normalem%                   %     Ändere dabei das Verhalten vom '\emph' nicht
%]{ulem}%
\RequirePackage{soul}           % Texthervorhebung (z.B. Unter- und Durchstreichung)

\RequirePackage[%               % Text-Färbung:
    dvipsnames%                 %     Gibt mehr Farben einen Namen
]{xcolor}

\RequirePackage[%               % bessere Aufzählungen
    shortlabels%                %     erlaubt Kurzschreibweise der Labels an Aufzählungen
]{enumitem}

\RequirePackage{blindtext}      % erlaubt Blindtext

\PassOptionsToPackage{hyphens}{url}
% Pass option "hyphens" to the package url which is loaded internally in hyperref to allow url breaking after a hyphen.

\ifFK@draft
    % Entwurfs-Wasserzeichen
    \RequirePackage{draftwatermark}
    \SetWatermarkText{Entwurf}

    % Use draft mode of KoMa class
    \KOMAoptions{draft}
\fi

% Hier eingebunden, da die KOMAoption "draft" überschrieben werden muss
\RequirePackage[%               % Kopf- und Fußzeilen.
    draft=false%                % Verhindert das Anzeigen von "Entwurfs-Informationen"
]{scrlayer-scrpage}

\RequirePackage[%               % Jura-Umgebungen
    clausemark=false,%          % Zeige keine Kolumnentitel an
    juratotoc,%                 % Füge Paragraphen zum TOC hinzu
    juratocnumberwidth=2.5em%   % Mehr Platz im TOC für die Paragraphen-Nummerierung
]{scrjura}

\RequirePackage{hyperref}       % Verlinkung (sowohl im Dokument als auch Hyperlinks)

%
% Command Declaration
%

\renewcommand*\url[1]{\href{https://#1}{\nolinkurl{#1}}}
% The original command does not work when #1 does not begin with "www".

\newcommand*\mail[1]{\href{mailto:#1}{\nolinkurl{#1}}}

% Wir geben im Titel keinen Autor an.
% Allerdings geht die Klasse scrartcl zwingend von einem Autor aus und fügt
% unnötigen whitespace ein, auch wenn das Autorfeld leer angegeben wird.
% Daher wird hier der Befehl \@maketitle umdefiniert:
% Es wird die bisherige Implementation des Befehls reinkopiert,
% mit der Änderung, dass das Autorfeld ignoriert wird, wenn es leer ist,
% und dann kein überzähliger Whitespace eingefügt wird.
\def\@maketitle{%
  \global \@topnum =\z@ \setparsizes {\z@ }{\z@ }{\z@ \@plus 1fil}\par@updaterelative
  \ifx \@titlehead \@empty
  \else \begin {minipage}[t]{\textwidth } \usekomafont {titlehead}{\@titlehead \par }\end {minipage}\par
  \fi
  \null
  \vskip 2em
  \begin {center}
    \ifx \@subject \@empty
    \else {\usekomafont {subject}{\@subject \par}}\vskip 1.5em
    \fi
    {\usekomafont {title}{\huge \@title \par }}%
    \vskip .5em {
      \ifx \@subtitle \@empty
      \else \usekomafont {subtitle}\@subtitle \par 
      \fi }%
% The following part is changed. The code inside the \else is the code that was used before.
% --------------------------------
    \ifx \@author \@empty
    \else
      \vskip 1em {
        \usekomafont {author}{
          \lineskip .5em%
          \begin {tabular}[t]{c}
            \@author
          \end {tabular}\par }}%
    \fi%
% --------------------------------
    \vskip 1em{%
      \usekomafont {date}{\@date \par }}%
    \vskip \z@ \@plus 1em {\usekomafont {publishers}{\@publishers \par }}%
    \ifx \@dedication \@empty
    \else \vskip 2em {\usekomafont {dedication}{\@dedication \par }}
    \fi
  \end {center}\par \vskip 2em%
}

%
% Layout
%

\pagestyle{scrheadings}

% Makes marginpar ragged.
\let\oldmarginpar\marginpar
\renewcommand\marginpar[1]{\oldmarginpar{\scriptsize \normalcolor \raggedright #1}}

% Randspaltenbemerkung an der linken Spalte
\reversemarginpar

% Configure further options of the "hyperref" package: colored links.
\hypersetup{%
	colorlinks=true,%
	linkcolor=orange,%
	citecolor=olive,%
	urlcolor=cyan%
}

% Use serif font in all headings
\addtokomafont{disposition}{\rmfamily}

\addtokomafont{contract.Clause}{\rmfamily}

% Center the sections
\addtokomafont{section}{\centering}

\ifFK@multilinesections
    \renewcommand \sectionformat{\FK@sectionprefix~\arabic{section}}
    \renewcommand\sectionlinesformat[4]{%
       \@hangfrom{\hskip #2#3}\\{#4}%
    }
\else
    % Change the numbering of the sections
    \renewcommand \sectionformat{\FK@sectionprefix~\arabic{section}:\enskip}
\fi


%% Change the numbering of the sections in the TOC
%\renewcommand \thesection {Abschnitt~\arabic{section}:}
%\RedeclareSectionCommand[%
%tocnumwidth=7em
%]{section}

%Change spacing around contract environments
\setkeys{contract}{%
preskip=2ex plus 1ex minus .2ex,%
postskip=1.5ex plus .2ex%
}

\setlist[enumerate, 1]{
  label = {\arabic*.},
  ref = {\arabic*}
}
\setlist[enumerate, 2]{
  label= {\alph*.},
  ref = {\arabic*}
}

% use French spacing
\bbl@frenchspacing
