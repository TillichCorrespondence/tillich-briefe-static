<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="tei xs"
    version="3.0">
    
    <xsl:output encoding="UTF-8" media-type="text" omit-xml-declaration="true" indent="no"/>
    
   <xsl:template match="/">
\documentclass{article}
\usepackage[a4paper, margin=2.5cm]{geometry} % consistent layout
\usepackage{parskip}       % for better paragraph spacing

\usepackage{fontspec}        % For font management
\usepackage{polyglossia}     % For multilingual support
\setmainlanguage{german}  % Set main language
\setotherlanguage{greek}  % Set other language
\newfontfamily\greekfont{FreeSerif}
\usepackage[normalem]{ulem} % for strikethroughs


\usepackage{setspace} % control line spacing
\usepackage{parskip}
\usepackage[most]{tcolorbox}

\usepackage{xcolor}
\usepackage[headings]{ragged2e}
\usepackage[hidelinks]{hyperref}


% Custom commands for marking entities (persons, places, and works)
% Small dark-gray icons positioned as superscript indicate these are in the indices
\newcommand{\pers}[1]{#1\textsuperscript{*}}
\newcommand{\place}[1]{#1\textsuperscript{*}}
\newcommand{\work}[1]{#1\textsuperscript{*}}

\title{<xsl:value-of select="normalize-space(.//tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title)"/>}
\author{<xsl:choose>
            <xsl:when test=".//tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:respStmt/tei:name">
                <xsl:text>Herausgegeben von </xsl:text>
                <xsl:value-of select=".//tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:respStmt/tei:name"/>
            </xsl:when>
        </xsl:choose>}        
\date{2025}  

\begin{document}
\maketitle 

        <!-- Überlieferung box -->
        <xsl:apply-templates select=".//tei:teiHeader/tei:fileDesc/tei:sourceDesc"/>
        
        <!-- Letter body -->
         <xsl:for-each select=".//tei:body//tei:div[@type='writingSession']">
            \begin{FlushRight}
            <xsl:apply-templates select=".//tei:dateline"/>
            \end{FlushRight}

            \begin{FlushLeft}
            <xsl:value-of select=".//tei:opener/tei:salute//text()"/>
            \end{FlushLeft}

            <xsl:for-each select=".//tei:p[not(parent::tei:postscript)]">
                \par
                <xsl:if test="position()=1">\noindent </xsl:if>
                <xsl:apply-templates/>
                \par 
            </xsl:for-each>

            \bigskip
            <xsl:apply-templates select=".//tei:closer"/>

        </xsl:for-each>
        
        <!-- Indices from back matter -->
        <xsl:apply-templates select=".//tei:text/tei:back"/>
\end{document} 
    </xsl:template>
    
    <!-- Überlieferung (sourceDesc) -->
    <xsl:template match="tei:sourceDesc">
\begin{tcolorbox}[colback=gray!5, colbacktitle=gray!75!black, title=Überlieferung, fonttitle=\bfseries]

\textbf{Aufbewahrungsort:} <xsl:value-of select="normalize-space(tei:msDesc/tei:msIdentifier/tei:repository)"/>, <xsl:value-of select="normalize-space(tei:msDesc/tei:msIdentifier/tei:institution)"/>, <xsl:value-of select="normalize-space(tei:msDesc/tei:msIdentifier/tei:country)"/>

\textbf{Signatur:} <xsl:value-of select="normalize-space(tei:msDesc/tei:msIdentifier/tei:idno)"/>

\textbf{Brieftyp:} <xsl:for-each select="tei:msDesc/tei:physDesc/tei:p">
                         <xsl:value-of select="normalize-space(.)"/>
                         <xsl:if test="position() != last()">
                             <xsl:text> </xsl:text><!-- adds space between paragraphs -->
                         </xsl:if>
                     </xsl:for-each>

\textbf{Postweg:} <xsl:apply-templates select="//tei:correspAction[@type='sent']/tei:placeName" mode="place-marker"/> — 
<xsl:choose>
    <xsl:when test="//tei:correspAction[@type='received']/tei:placeName">
        <xsl:apply-templates select="//tei:correspAction[@type='received']/tei:placeName" mode="place-marker"/>
    </xsl:when>
    <xsl:otherwise>
        <xsl:text>unbekannt</xsl:text>
    </xsl:otherwise>
</xsl:choose>
[Empfänger: <xsl:apply-templates select="//tei:correspAction[@type='received']/tei:persName" mode="pers-marker"/>]

\end{tcolorbox}
\vspace{1cm}
    </xsl:template>    
    
 

    <!-- Dateline -->
     <xsl:template match="tei:dateline">
        <xsl:value-of select="replace(normalize-space(string-join(.//text())),' , ', ', ')"/>
    </xsl:template>

    <!-- Salute -->
    <xsl:template match="tei:salute">
        <xsl:apply-templates/>\par\smallskip        
    </xsl:template>   
   
    
 
    
    <!-- Text formatting -->
    <xsl:template match="tei:hi[@rend='u']">\underline{<xsl:apply-templates/>}</xsl:template>
    
    <xsl:template match="tei:hi[@rend='uu']">\underline{\underline{<xsl:apply-templates/>}}</xsl:template>
    
    <xsl:template match="tei:hi[@rend='aq']">\textit{<xsl:apply-templates/>}</xsl:template>
    
    <!-- References to persons -->
    <xsl:template match="tei:rs[@type='person']">\pers{<xsl:apply-templates/>}</xsl:template>
    
    <xsl:template match="tei:persName">\pers{<xsl:apply-templates/>}</xsl:template>
    
    <xsl:template match="tei:persName" mode="pers-marker">\pers{<xsl:value-of select="normalize-space(.)"/>}</xsl:template>
    
    <!-- References to places -->
    <xsl:template match="tei:rs[@type='place']">\place{<xsl:apply-templates/>}</xsl:template>
    
    <xsl:template match="tei:placeName">\place{<xsl:apply-templates/>}</xsl:template>
    
    <xsl:template match="tei:placeName" mode="place-marker">\place{<xsl:value-of select="normalize-space(.)"/>}</xsl:template>
    
    <!-- References to works -->
    <xsl:template match="tei:rs[@type='work']">\work{<xsl:apply-templates/>}</xsl:template>
    
    <!-- Footnotes -->
    <xsl:template match="tei:note">
        <xsl:text>\footnote{</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>}</xsl:text>
    </xsl:template>
    
    <!-- Quotes -->
    <xsl:template match="tei:q">
        <xsl:text>„</xsl:text><xsl:apply-templates/><xsl:text>“</xsl:text>  
    </xsl:template>
    
    <!-- Foreign text (Greek) -->
    <xsl:template match="tei:foreign[@xml:lang='grc']">
        <xsl:text>\begin{greek}</xsl:text><xsl:apply-templates/><xsl:text>\end{greek}</xsl:text>
    </xsl:template>

    <!-- Unclear text -->
    <xsl:template match="tei:unclear">
    <xsl:text>[</xsl:text><xsl:apply-templates/><xsl:text>]</xsl:text>
</xsl:template>
    
    <!-- Deletions -->
    <xsl:template match="tei:del">\sout{<xsl:value-of select="."/>}</xsl:template>    
    
    <!-- Choices (abbreviations, etc.) -->
    <xsl:template match="tei:choice">
        <xsl:apply-templates select="tei:expan"/>
    </xsl:template>
    
    <!-- Back matter: Indices -->
    <xsl:template match="tei:back">
\vspace{1em}
\hrulefill
\vspace{1em}
        <!-- Person index -->
        <xsl:if test="tei:listPerson/tei:person">
\noindent\textbf{\Large Personenregister}

\vspace{0.5cm}

\begin{description}
            <xsl:apply-templates select="tei:listPerson/tei:person">
                <xsl:sort select="tei:persName/tei:surname"/>
            </xsl:apply-templates>
\end{description}

\vspace{1cm}

        </xsl:if>
        
        <!-- Bibliography -->
        <xsl:if test="tei:listBibl/tei:biblStruct">
\noindent\textbf{\Large Literaturverzeichnis}

\vspace{0.5cm}

\begin{description}
            <xsl:apply-templates select="tei:listBibl/tei:biblStruct"/>
\end{description}

\vspace{1cm}

        </xsl:if>
        
        <!-- Place index -->
        <xsl:if test="tei:listPlace/tei:place">
\noindent\textbf{\Large Ortsregister}

\vspace{0.5cm}

\begin{description}
            <xsl:apply-templates select="tei:listPlace/tei:place">
                <xsl:sort select="tei:placeName"/>
            </xsl:apply-templates>
\end{description}
        </xsl:if>
    </xsl:template>
    
    <!-- Person entries -->
    <xsl:template match="tei:person">
\item[<xsl:value-of select="normalize-space(tei:persName)"/>]
\small <xsl:if test="tei:birth/tei:date or tei:death/tei:date"> (<xsl:if test="tei:birth/tei:date"><xsl:value-of select="tei:birth/tei:date"/></xsl:if>--<xsl:if test="tei:death/tei:date"><xsl:value-of select="tei:death/tei:date"/></xsl:if>)</xsl:if><xsl:if test="tei:occupation"> <xsl:value-of select="tei:occupation"/>.</xsl:if><xsl:if test="tei:note[@type='bio']"> <xsl:apply-templates select="tei:note[@type='bio']/tei:p"/></xsl:if><xsl:if test="tei:idno[@type='gnd']"> [GND: \url{<xsl:value-of select="tei:idno[@type='gnd']"/>}]</xsl:if>

    </xsl:template>
    
    <!-- Place entries -->
    <xsl:template match="tei:place">
\item[<xsl:value-of select="normalize-space(tei:placeName)"/>]
\small <xsl:if test="tei:idno[@type='geonames'] or tei:idno[@type='wikidata']"> [<xsl:if test="tei:idno[@type='geonames']">Geonames: \url{<xsl:value-of select="tei:idno[@type='geonames']"/>}</xsl:if><xsl:if test="tei:idno[@type='geonames'] and tei:idno[@type='wikidata']">; </xsl:if><xsl:if test="tei:idno[@type='wikidata']">Wikidata: \url{<xsl:value-of select="tei:idno[@type='wikidata']"/>}</xsl:if>]</xsl:if>

    </xsl:template>
    
    <!-- Bibliography entries -->
    <xsl:template match="tei:biblStruct">
        \item
        <xsl:choose>
            
            <!-- Case 1: Journal article -->
            <xsl:when test="@type='journalArticle' or tei:analytic">
                <xsl:if test="tei:analytic/tei:author">
                    <xsl:value-of select="tei:analytic/tei:author/tei:surname"/>,
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="tei:analytic/tei:author/tei:forename"/>
                    <xsl:text>: </xsl:text>
                </xsl:if>
                
                <xsl:text>„</xsl:text>
                <xsl:value-of select="tei:analytic/tei:title[@level='a']"/>
                <xsl:text>“</xsl:text>
                
                <xsl:text>. </xsl:text>
                <xsl:text>\textit{</xsl:text>
                <xsl:value-of select="tei:monogr/tei:title[@level='j']"/>
                <xsl:text>}</xsl:text>
                
                <xsl:if test="tei:monogr/tei:imprint/tei:biblScope[@unit='issue']">
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="tei:monogr/tei:imprint/tei:biblScope[@unit='issue']"/>
                </xsl:if>
                
                <xsl:if test="tei:monogr/tei:imprint/tei:biblScope[@unit='page']">
                    <xsl:text>, S. </xsl:text>
                    <xsl:value-of select="tei:monogr/tei:imprint/tei:biblScope[@unit='page']"/>
                </xsl:if>
                
                <xsl:if test="tei:monogr/tei:imprint/tei:date">
                    <xsl:text> (</xsl:text>
                    <xsl:value-of select="tei:monogr/tei:imprint/tei:date"/>
                    <xsl:text>).</xsl:text>
                </xsl:if>
            </xsl:when>
            
            <!-- Case 2: Monograph (book) -->
            <xsl:otherwise>
                <xsl:if test="tei:monogr/tei:author">
                    <xsl:value-of select="tei:monogr/tei:author/tei:surname"/>,
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="tei:monogr/tei:author/tei:forename"/>
                    <xsl:text>: </xsl:text>
                </xsl:if>
                \textit{<xsl:value-of select="tei:monogr/tei:title[@level='m']"/>}
                <xsl:if test="tei:monogr/tei:imprint">
                    <xsl:text>. </xsl:text>
                    <xsl:if test="tei:monogr/tei:imprint/tei:publisher">
                        <xsl:value-of select="tei:monogr/tei:imprint/tei:publisher"/>,
                        <xsl:text> </xsl:text>
                    </xsl:if>
                    <xsl:value-of select="tei:monogr/tei:imprint/tei:date"/>.
                </xsl:if>
            </xsl:otherwise>
            
        </xsl:choose>
    </xsl:template>
    
    
    
    
</xsl:stylesheet>
