<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="tei xs"
    version="3.0">
    
    <xsl:output encoding="UTF-8" media-type="text" omit-xml-declaration="true" indent="no"/>
<!--    collect all rs person ref atrributes also joined entities like 'Eltern'-->
    <xsl:variable name="persons-used"
        select="distinct-values(
        tokenize(
        string-join(
        (//tei:rs[@type='person']/@ref,
        //tei:persName[@ref]/@ref),
        ' '
        ),
        '\s+'
        ) ! substring-after(., '#')
        )"/>
    
    
    
    
    
    
   <xsl:template match="/">
\documentclass{article}
\usepackage[a4paper, margin=2.5cm]{geometry} % consistent layout
\usepackage{parskip}       % for better paragraph spacing

\usepackage{xurl} % to handle url linebreak

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

\textbf{Signatur:} <xsl:for-each select="tei:msDesc/tei:msIdentifier/tei:idno">
                         <xsl:value-of select="normalize-space(.)"/>
                         <xsl:if test="position() != last()">
                             <xsl:text> | </xsl:text><!-- adds space between idnos -->
                         </xsl:if>
                     </xsl:for-each>

\textbf{Brieftyp:} <xsl:for-each select="tei:msDesc/tei:physDesc/tei:p">
                         <xsl:value-of select="normalize-space(.)"/>
                         <xsl:if test="position() != last()">
                             <xsl:text> </xsl:text><!-- adds space between paragraphs -->
                         </xsl:if>
                     </xsl:for-each>

\textbf{Postweg:} <xsl:apply-templates select="//tei:correspAction[@type='sent']/tei:placeName"/> — 
<xsl:choose>
    <xsl:when test="//tei:correspAction[@type='received']/tei:placeName">
        <xsl:apply-templates select="//tei:correspAction[@type='received']/tei:placeName"/>
    </xsl:when>
    <xsl:otherwise>
        <xsl:text>unbekannt</xsl:text>
    </xsl:otherwise>
</xsl:choose>
[Empfänger: <xsl:apply-templates select="//tei:correspAction[@type='received']/tei:persName"/>]

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
    <xsl:template match="tei:rs[@type='person'][@ref] | tei:persName[@ref]">
        
        <xsl:variable name="ids"
            select="for $i in tokenize(@ref, '\s+')
            return substring-after($i,'#')"/>
        
        <xsl:apply-templates/>
        
        <xsl:for-each select="$ids">
            <xsl:variable name="pos" select="index-of($persons-used, .)"/>
            <xsl:variable name="letter" select="codepoints-to-string(96 + $pos)"/>
            <xsl:text>\textsuperscript{</xsl:text>
            <xsl:value-of select="$letter"/>
            <xsl:text>}</xsl:text>
        </xsl:for-each>
        
    </xsl:template>
    
    
    
    
    
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
        <xsl:choose>
            <xsl:when test="@rend='single'">
                <xsl:text>‚</xsl:text>
                <xsl:apply-templates/>
                <xsl:text>’</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>„</xsl:text>
                <xsl:apply-templates/>
                <xsl:text>“</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
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
            <xsl:apply-templates select="tei:listPerson/tei:person[@xml:id = $persons-used]">
                <xsl:sort select="index-of($persons-used, @xml:id)"/>
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
        
        <xsl:variable name="id" select="@xml:id"/>
        <xsl:variable name="pos" select="index-of($persons-used, $id)"/>
        <xsl:variable name="letter" select="codepoints-to-string(96 + $pos)"/>
        
        \item[\textsuperscript{<xsl:value-of select="$letter"/>} <xsl:value-of select="normalize-space(tei:persName)"/>]
        {\small <xsl:if test="tei:birth/tei:date or tei:death/tei:date"> 
            (<xsl:if test="tei:birth/tei:date"><xsl:value-of select="tei:birth/tei:date"/></xsl:if>--
            <xsl:if test="tei:death/tei:date"><xsl:value-of select="tei:death/tei:date"/></xsl:if>)</xsl:if>
        <xsl:if test="tei:occupation"> <xsl:value-of select="tei:occupation"/>.</xsl:if>
        <xsl:if test="tei:note[@type='bio']"> <xsl:apply-templates select="tei:note[@type='bio']/tei:p"/></xsl:if>
        <xsl:if test="tei:idno[@type='gnd']"> [GND: \url{<xsl:value-of select="tei:idno[@type='gnd']"/>}]</xsl:if>}
        
    </xsl:template>
    
    <!-- Place entries -->
    <xsl:template match="tei:place">
        \item[<xsl:value-of select="normalize-space(tei:placeName)"/>]
        {\small <xsl:if test="tei:idno[@type='geonames'] or tei:idno[@type='wikidata']"> [<xsl:if test="tei:idno[@type='geonames']">Geonames: \url{<xsl:value-of select="tei:idno[@type='geonames']"/>}</xsl:if><xsl:if test="tei:idno[@type='geonames'] and tei:idno[@type='wikidata']">; </xsl:if><xsl:if test="tei:idno[@type='wikidata']">Wikidata: \url{<xsl:value-of select="tei:idno[@type='wikidata']"/>}</xsl:if>]</xsl:if>}
        
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
    <xsl:template match="text()">
        <xsl:variable name="t1"  select="replace(., '\\', '\\textbackslash{}')"/>
        <xsl:variable name="t2"  select="replace($t1, '_', '\\_')"/>
        <xsl:variable name="t3"  select="replace($t2, '&amp;', '\\&amp;')"/>
        <xsl:variable name="t4"  select="replace($t3, '%', '\\%')"/>
        <xsl:variable name="t5"  select="replace($t4, '#', '\\#')"/>
        <xsl:variable name="t6"  select="replace($t5, '\$', '\\$')"/>
        <xsl:variable name="t7"  select="replace($t6, '\{', '\\{')"/>
        <xsl:variable name="t8"  select="replace($t7, '\}', '\\}')"/>
        <xsl:value-of select="$t8"/>
    </xsl:template>
    
    <xsl:template match="text()">
        <xsl:call-template name="escape_character_latex">
            <xsl:with-param name="context" select="."/>
        </xsl:call-template>
    </xsl:template>
    
    
    <!--    escaping special characters-->
    <xsl:template name="escape_character_latex">
        <xsl:param name="context"/>
        <xsl:analyze-string select="$context" regex="([&amp;])|([_])|([$])|([%])|([{{])|([}}])|([#])|((\w)\-(\w))|([/])|([§] +)|((\d{{1,2}}\.)\s+(\d{{1,2}}\.)\s+([21][8901]\d{{2}}))">
            <xsl:matching-substring>
                <xsl:choose>
                    <xsl:when test="regex-group(1)">
                        <xsl:text disable-output-escaping="yes">\&amp;</xsl:text>
                    </xsl:when>
                    <xsl:when test="regex-group(2)">
                        <xsl:text>\_</xsl:text>
                    </xsl:when>
                    <xsl:when test="regex-group(3)">
                        <xsl:text>\$</xsl:text>
                    </xsl:when>
                    <xsl:when test="regex-group(4)">
                        <xsl:text>\%</xsl:text>
                    </xsl:when>
                    <xsl:when test="regex-group(5)">
                        <xsl:text>{</xsl:text>
                    </xsl:when>
                    <xsl:when test="regex-group(6)">
                        <xsl:text>}</xsl:text>
                    </xsl:when>
                    <xsl:when test="regex-group(7)">
                        <xsl:text>\#</xsl:text>
                    </xsl:when>
                    <xsl:when test="regex-group(8)">
                        <xsl:value-of select="regex-group(9)"/>
                        <xsl:text>"=</xsl:text>
                        <!-- used with the hyphenat package to allow hyphenation of hyphenated-words -->
                        <!--replaced by some TeX magic as this creates hassle in index-->
                        <!-- 20220202 replaced by "- to allow breakpoints -->
                        <xsl:value-of select="regex-group(10)"/>
                    </xsl:when>
                    <xsl:when test="regex-group(11)">
                        <xsl:text>{\slash}</xsl:text><!-- allow breaking at / -->
                    </xsl:when>
                    <xsl:when test="regex-group(12)">
                        <xsl:text>§~</xsl:text>
                    </xsl:when>
                    <xsl:when test="regex-group(13)"><!-- hairspace in dates -->
                        <xsl:value-of select="regex-group(14)"/>
                        <xsl:text>\,</xsl:text>
                        <xsl:value-of select="regex-group(15)"/>
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="regex-group(16)"/>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:value-of select="."/>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>
    
    
</xsl:stylesheet>
