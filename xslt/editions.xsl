<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:local="http://dse-static.foo.bar"    
    xmlns:mam="whatever" version="2.0" exclude-result-prefixes="xsl tei xs">
    <xsl:output encoding="UTF-8" media-type="text/html" method="xhtml" version="1.0" indent="yes" omit-xml-declaration="yes"/>
    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="./partials/html_footer.xsl"/>
    <xsl:import href="./partials/html_title_navigation.xsl"/>
    <xsl:import href="./partials/view-type.xsl"/>
    <xsl:import href="partials/shared.xsl"/>
    <xsl:template match="/">
        <xsl:variable name="doc_title">
            <xsl:value-of select=".//tei:titleStmt/tei:title[1]/text()"/>
        </xsl:variable>
        <xsl:variable name="doc_id">
            <xsl:value-of select=".//tei:TEI/@xml:id"/>
        </xsl:variable>
        <xsl:variable name="doc-url">
            <xsl:value-of select="concat('https://tillich-briefe.acdh.oeaw.ac.at/', replace($doc_id, '.xml', '.html'))"/>
        </xsl:variable>
        <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
        <html xmlns="http://www.w3.org/1999/xhtml">
            <head>
                <xsl:call-template name="html_head">
                    <xsl:with-param name="html_title" select="$doc_title"/>
                </xsl:call-template>
            </head>
            <body class="page">
                <div class="hfeed site" id="page">
                    <xsl:call-template name="nav_bar"/>
                    <div class="container-fluid">
                        <div class="wp-transcript">
                            <div class="card" data-index="true">
                                <div class="card-header">
                                    <xsl:call-template name="header-nav"/>
                                </div>
                                <div id="container-resize" class="row transcript active">
                                    <xsl:for-each select="descendant::tei:body"><foreign xml:lang="lat"></foreign>
                                        <xsl:call-template name="mam:view-type-img"/>
                                    </xsl:for-each>
                                </div>
                            </div>
                            <div class="card-footer" style="clear: both;">
                                <nav class="navbar navbar-expand-lg" style="box-shadow: none;">
                                    <div class="container-fluid" style="display: flex;
                                        justify-content: center;
                                        align-items: center;">
                                        <div id="navbarSupportedContent">
                                            <ul class="navbar-nav mb-2 mb-lg-0" id="secondary-menu">
                                                <li class="nav-item"> &#160;
                                                    <a href="#" data-bs-target="#entitaeten" type="button" data-bs-toggle="modal" onclick="showEntities()">
                                                        <i class="fas fa-sharp fa-solid fa-people-group"/>
                                                        <xsl:text>ENTITÄTEN</xsl:text>
                                                    </a>&#160; 
                                                </li>
                                                <li class="nav-item"> &#160;
                                                    <a href="#" data-bs-target="#zitat" type="button" data-bs-toggle="modal">
                                                        <i class="fas fa-quote-right"/>
                                                        <xsl:text>ZITIEREN</xsl:text>
                                                    </a>&#160; 
                                                </li>
                                                <li class="nav-item"> &#160;
                                                    <a>
                                                        <xsl:attribute name="href">
                                                            <xsl:value-of select="$doc_id"/>
                                                        </xsl:attribute>
                                                        <xsl:attribute name="download" />
                                                        <i class="fas fa-solid fa-download"/>
                                                        <xsl:text>DOWNLOAD</xsl:text>
                                                    </a>&#160;
                                                </li>
                                                <!--                                         <li class="nav-item"> &#160;
                                            <a href="#" data-bs-target="#tagfuertag" type="button" data-bs-toggle="modal">
                                                <i class="fas fa-calendar-day"/>
                                                <xsl:text>CHRONIK</xsl:text>
                                            </a>&#160; 
                                        </li> -->
                                            </ul>
                                        </div>
                                    </div>
                                </nav>
                                <xsl:if test="descendant::tei:note[@type = 'eb' or @type = 'ea']">
                                    <div class="card-body-anhang">
                                        <dl class="kommentaranhang">
                                            <xsl:apply-templates select="descendant::tei:note[@type = 'eb' or @type = 'ea']" mode="kommentaranhang"/>
                                        </dl>
                                    </div>
                                </xsl:if>
                            </div>
                        </div>
                    </div>

                    <xsl:call-template name="html_footer"/>
                    <script src="https://unpkg.com/de-micro-editor@0.2.83/dist/de-editor.min.js"/>
                    <script type="text/javascript" src="js/run.js"/>
                    <script type="text/javascript" src="js/prev-next-urlupdate.js"/>
                    <script type="text/javascript" src="js/date.js"/>
                    <script type="text/javascript" src="js/editions.js"/>
                    <!-- Modal Zitat -->
                    <div class="modal fade" id="zitat" tabindex="-1" aria-labelledby="zitatModalLabel" aria-hidden="true">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title" id="exampleModalLabel">Zitat</h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Schließen"/>
                                </div>
                                <div class="modal-body">
                                    <p>Eine zitierfähige Angabe dieser Seite lautet:</p>
                                    <blockquote>
                                        <xsl:value-of select=".//tei:titleStmt/tei:title[1]/text()"/>
                                        <xsl:text>, in: Paul Tillich, Korrespondenz. Digitale Edition, hg. von Christian Danz und Friedrich Wilhelm Graf. </xsl:text>
                                        <xsl:value-of select="$doc-url"/>
                                        <xsl:text>, Zugriff am </xsl:text>
                                        <span class="currentDate">????</span>
                                        <xsl:text>.</xsl:text>
                                    </blockquote>
                                    <p>Für gekürzte Zitate reicht die Angabe der Briefnummer aus, die
                                    eindeutig und persistent ist: »<b><xsl:value-of select="tei:TEI/@xml:id"/></b>«.
                                    </p>
                                    <p>
                                    Für Belege in der Wikipedia kann diese Vorlage benutzt
                                    werden:
                                    </p>
                                    <blockquote>
                                        <code>
                                            {{Internetquelle |url=<xsl:value-of select="$doc-url"/>
                                            <xsl:text> |titel=</xsl:text>
                                            <xsl:value-of select=".//tei:titleStmt/tei:title[1]"/>
                                            <xsl:text> |werk=Paul Tillich, Korrespondenz. Digitale Edition. |hrsg=Christian Danz, Friedrich Wilhelm Graf |sprache=de | datum=</xsl:text>
                                            <xsl:value-of select="//tei:correspAction[@type = 'sent']/tei:date[@when]"/>
                                            <xsl:text> |abruf=</xsl:text>
                                            <span class="currentDateYYYYMMDD">????</span>
                                            <xsl:text> }}</xsl:text>
                                        </code>
                                    </blockquote>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Schließen</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </body>
        </html>
    </xsl:template>
    <!-- Regeln für Elemente -->
    <xsl:template match="tei:address">
        <div class="column">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="tei:addrLine">
        <div class="addrLine">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="tei:back"/>
    <xsl:template match="tei:text//tei:note[@type = 'commentary' or @type = 'textConst']//tei:bibl">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="tei:c[@rendition = '#kaufmannsund']">
        <xsl:text>&amp;</xsl:text>
    </xsl:template>
    <xsl:template match="tei:c[@rendition = '#tilde']">~</xsl:template>
    <xsl:template match="tei:c[@rendition = '#geschwungene-klammer-auf']">
        <xsl:text>{</xsl:text>
    </xsl:template>
    <xsl:template match="tei:cell">
        <xsl:element name="td">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:date[@*]">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="tei:div[not(@type = 'address')]">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="tei:div[@type = 'address']">
        <div class="address-div">
            <xsl:apply-templates/>
        </div>
        <br/>
    </xsl:template>
    <xsl:template match="tei:formula[@notation = 'TeX']">
        <xsl:variable name="modifiedText">
            <xsl:call-template name="replace-fractions">
                <xsl:with-param name="text" select="."/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:value-of select="$modifiedText"/>
    </xsl:template>
    <!-- Template to replace \frac{n}{m} with n/m -->
    <xsl:template name="replace-fractions">
        <xsl:param name="text"/>
        <xsl:variable name="regex" select="'\\frac\{([^}]+)\}\{([^}]+)\}'"/>
        <xsl:variable name="replacement" select="'$1/$2'"/>
        <xsl:value-of select="replace($text, $regex, $replacement)"/>
    </xsl:template>
    <xsl:template match="tei:gap">
        <xsl:choose>
            <xsl:when test="@reason = 'deleted'">
                <span class="del gap">
                    <xsl:attribute name="alt">
                        <xsl:value-of select="data(@reason)"/>
                    </xsl:attribute>
                    <xsl:text>[</xsl:text>
                    <xsl:apply-templates/>
                    <xsl:text>]</xsl:text>
                </span>
            </xsl:when>
            <xsl:when test="@reason = 'illegible'">
                <span class="gap">
                    <xsl:attribute name="alt">
                        <xsl:value-of select="data(@reason)"/>
                    </xsl:attribute>
                    <xsl:text>[</xsl:text>
                    <xsl:apply-templates/>
                    <xsl:text>]</xsl:text>
                </span>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:gap[@unit = 'chars' and @reason = 'illegible']">
        <span class="illegible">
            <xsl:value-of select="mam:gaps(@quantity)"/>
        </span>
    </xsl:template>
    <xsl:function name="mam:gaps">
        <xsl:param name="anzahl"/>
        <xsl:text>×</xsl:text>
        <xsl:if test="$anzahl &gt; 1">
            <xsl:value-of select="mam:gaps($anzahl - 1)"/>
        </xsl:if>
    </xsl:function>
    <xsl:template match="tei:gap[@unit = 'lines' and @reason = 'illegible']">
        <div class="illegible">
            <xsl:text> [</xsl:text>
            <xsl:value-of select="@quantity"/>
            <xsl:text> Zeilen unleserlich] </xsl:text>
        </div>
    </xsl:template>
    <xsl:template match="tei:gap[@reason = 'outOfScope']">
        <span class="outOfScope">[…]</span>
    </xsl:template>
    <!-- Überschriften -->
    <xsl:template match="tei:head">
        <xsl:if test="@xml:id[starts-with(., 'org') or starts-with(., 'ue')]">
            <a>
                <xsl:attribute name="name">
                    <xsl:value-of select="@xml:id"/>
                </xsl:attribute>
                <xsl:text></xsl:text>
            </a>
        </xsl:if>
        <a>
            <xsl:attribute name="name">
                <xsl:text>hd</xsl:text>
                <xsl:number level="any"/>
            </xsl:attribute>
            <xsl:text></xsl:text>
        </a>
        <h3>
            <div>
                <xsl:apply-templates/>
            </div>
        </h3>
    </xsl:template>
    <xsl:template match="tei:item">
        <li>
            <xsl:apply-templates/>
        </li>
    </xsl:template>
    <xsl:template match="tei:l">
        <xsl:apply-templates/>
        <br/>
    </xsl:template>
    <xsl:template match="tei:lb">
        <br/>
    </xsl:template>
    <xsl:template match="tei:lg">
        <span style="display:block;margin: 1em 0;">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template match="tei:lg[@type = 'poem' and not(descendant::lg[@type = 'stanza'])]">
        <div class="poem ">
            <ul>
                <xsl:apply-templates/>
            </ul>
        </div>
    </xsl:template>
    <xsl:template match="tei:lg[@type = 'poem' and descendant::lg[@type = 'stanza']]">
        <div class="poem ">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="tei:lg[@type = 'stanza']">
        <ul>
            <xsl:apply-templates/>
        </ul>
        <xsl:if test="not(position() = last())">
            <br/>
        </xsl:if>
    </xsl:template>
    <xsl:template match="tei:list">
        <ul>
            <xsl:apply-templates/>
        </ul>
    </xsl:template>
    <!--    footnotes -->
    <xsl:template match="tei:note[@type = 'footnote']">
        <xsl:if test="preceding-sibling::*[1][name() = 'note' and @type = 'footnote']">
            <!-- Sonderregel für zwei Fußnoten in Folge -->
            <sup>
                <xsl:text>,</xsl:text>
            </sup>
        </xsl:if>
        <xsl:element name="a">
            <xsl:attribute name="class">
                <xsl:choose>
                    <xsl:when test="ancestor::tei:hi[@rend = 'pre-print'][ancestor::tei:note]">

                        <xsl:text>pre-print</xsl:text>

                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>reference-black</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:attribute name="href">
                <xsl:text>#footnote</xsl:text>
                <xsl:number level="any" count="tei:note[@type = 'footnote']" format="1"/>
            </xsl:attribute>
            <sup>
                <xsl:number level="any" count="tei:note[@type = 'footnote']" format="1"/>
            </sup>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:note[@type = 'footnote']" mode="footnote">
        <xsl:element name="li">
            <xsl:attribute name="id">
                <xsl:text>footnote</xsl:text>
                <xsl:number level="any" count="tei:note[@type = 'footnote']" format="1"/>
            </xsl:attribute>
            <xsl:attribute name="class">
                <xsl:choose>
                    <xsl:when test="ancestor::tei:hi[@rend = 'pre-print'][ancestor::tei:note]">

                        <xsl:text>pre-print</xsl:text>

                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>reference-black</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <sup>
                <xsl:number level="any" count="tei:note[@type = 'footnote']" format="1"/>
            </sup>
            <xsl:text></xsl:text>
            <xsl:apply-templates mode="footnote"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:p[parent::tei:note]" mode="footnote">
        <xsl:if test="not(position() = 1)">
            <br/>
        </xsl:if>
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="tei:note[@type = 'eb' or @type = 'ea']">
        <sup>
            <xsl:number level="any" count="tei:note[@type = 'eb' or @type = 'ea']" format="1"/>
            <xsl:text>]</xsl:text>
        </sup>        
    </xsl:template>
    <xsl:template match="tei:opener">
        <div class="opener">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="tei:hi">
        <xsl:choose>
            <xsl:when test="@rend = 'i'">
                <i>
                    <xsl:apply-templates/>
                </i>
            </xsl:when>
            <xsl:when test="@rend = 'b'">
                <i>
                    <xsl:apply-templates/>
                </i>
            </xsl:when>
            <xsl:when test="@rend = 'u'">
                <i>
                    <xsl:apply-templates/>
                </i>
            </xsl:when>
            <xsl:when test="@rend = 'uu'">
                <!-- <u style="text-decoration: double underline;"> -->
                <i>
                    <xsl:apply-templates/>
                </i>
                <!-- </u> -->
            </xsl:when>
            <xsl:when test="@rend = 'g' or @rend = 'print' or @rend = 'hand' or @rend = 'aq'">
                <i>
                    <xsl:apply-templates/>
                </i>
            </xsl:when>
            <xsl:when test="@rend = 'sub'">
                <sub>
                    <xsl:apply-templates/>
                </sub>
            </xsl:when>
            <xsl:when test="@rend = 'sup'">
                <sup>
                    <xsl:apply-templates/>
                </sup>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:del">
        <s>
            <xsl:apply-templates/>
        </s>
    </xsl:template>
    <xsl:template match="tei:p[child::tei:space[@dim] and not(child::*[2]) and empty(text())]">
        <br/>
    </xsl:template>
    <xsl:template match="tei:p[parent::tei:quote]">
        <xsl:apply-templates/>
        <xsl:if test="not(position() = last())">
            <xsl:text> / </xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:template match="tei:p[not(parent::tei:quote) and (ancestor::tei:note or ancestor::tei:note[@type = 'footnote'] or ancestor::tei:caption or parent::tei:bibl)]">
        <xsl:choose>
            <xsl:when test="@rend = 'right'">
                <div align="right">
                    <xsl:apply-templates/>
                </div>
            </xsl:when>
            <xsl:when test="@rend = 'left'">
                <div align="left">
                    <xsl:apply-templates/>
                </div>
            </xsl:when>
            <xsl:when test="@rend = 'center'">
                <div align="center">
                    <xsl:apply-templates/>
                </div>
            </xsl:when>
            <xsl:when test="@rend = 'inline'">
                <div style="inline">
                    <xsl:apply-templates/>
                </div>
            </xsl:when>
            <xsl:otherwise>
                <div>
                    <xsl:apply-templates/>
                </div>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:persName[@key | @ref]">
        <xsl:element name="a">
            <xsl:attribute name="class">reference</xsl:attribute>
            <xsl:attribute name="data-type">listperson.xml</xsl:attribute>
            <xsl:attribute name="data-key">
                <xsl:value-of select="@key"/>
                <xsl:value-of select="@ref"/>
            </xsl:attribute>
            <xsl:value-of select="."/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:placeName[@key | @ref]">
        <xsl:element name="a">
            <xsl:attribute name="class">reference</xsl:attribute>
            <xsl:attribute name="data-type">listplace.xml</xsl:attribute>
            <xsl:attribute name="data-key">
                <xsl:value-of select="@key"/>
                <xsl:value-of select="@ref"/>
            </xsl:attribute>
            <xsl:value-of select="."/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:quote">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="tei:row">
        <xsl:element name="tr">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:salute[parent::tei:opener]">
        <p class="salute editionText">
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    <xsl:template match="tei:salute[not(parent::tei:opener)]">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="tei:signed">
        <div class="signed editionText">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <!--<xsl:template match="tei:space[@unit='chars' and not(@quantity = 1)]">
        <span class="space">
            <xsl:value-of select="
                    string-join((for $i in 1 to @quantity
                    return
                        '&#x00A0;'), '')"/>
        </span>
    </xsl:template>-->
    <xsl:template match="tei:space[@unit = 'chars' and @quantity = '1']">
        <xsl:text>&#x00A0;</xsl:text>
    </xsl:template>
    <xsl:template match="tei:space[@unit = 'chars' and @quantity = '1']" mode="verschachtelteA">
        <xsl:text>&#x00A0;</xsl:text>
    </xsl:template>
    <xsl:template match="text()[matches(., '\s+$') and following-sibling::node()[1][self::tei:space[@unit = 'chars' and @quantity = '1']]]">
        <xsl:value-of select="replace(., '\s+$', '')"/>
    </xsl:template>
    <xsl:template match="text()[matches(., '^\s+') and preceding-sibling::node()[1][self::tei:space[@unit = 'chars' and @quantity = '1']]]">
        <xsl:value-of select="replace(., '^\s+', '')"/>
    </xsl:template>

    <xsl:template match="tei:note" mode="verschachtelteA"/>
    <xsl:template match="tei:hi" mode="verschachtelteA">
        <xsl:element name="span">
            <xsl:attribute name="class">
                <xsl:choose>
                    <xsl:when test="@rend = 'underline'">
                        <xsl:choose>
                            <xsl:when test="@n = '1'">
                                <xsl:text>underline</xsl:text>
                            </xsl:when>
                            <xsl:when test="@n = '2'">
                                <xsl:text>doubleUnderline</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>tripleUnderline</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="@rend"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:space[@unit = 'line']">
        <xsl:value-of select="mam:spaci-space(@quantity, @quantity)"/>
    </xsl:template>
    <xsl:template match="tei:space[@unit = 'chars' and not(@quantity = 1)]">
        <xsl:variable name="weite" select="0.5 * @quantity"/>
        <xsl:element name="span">
            <xsl:attribute name="style">
                <xsl:value-of select="concat('display:inline-block; width: ', $weite, 'em; ')"/>
            </xsl:attribute>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:space[@dim = 'vertical' and not(@unit)]">
        <xsl:element name="div">
            <xsl:attribute name="style">
                <xsl:value-of select="concat('padding-bottom:', @quantity, 'em;')"/>
            </xsl:attribute>
        </xsl:element>
    </xsl:template>
    <!-- Tabellen -->
    <xsl:template match="tei:table">
        <xsl:element name="table">
            <xsl:if test="@xml:id">
                <xsl:attribute name="id">
                    <xsl:value-of select="data(@xml:id)"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:attribute name="class">
                <xsl:text>table </xsl:text>
            </xsl:attribute>
            <xsl:element name="tbody">
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:function name="mam:dots">
        <xsl:param name="anzahl"/>
 .        <xsl:if test="$anzahl &gt; 1">
            <xsl:value-of select="mam:dots($anzahl - 1)"/>
        </xsl:if>
    </xsl:function>
    <!-- Wechsel der Schreiber <handShift -->
    <xsl:template match="tei:handShift[not(@scribe)]">
        <xsl:choose>
            <xsl:when test="@medium = 'typewriter'">
                <span class="typewriter">
                    <xsl:text>[maschinenschriftlich:] </xsl:text>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <span class="handschriftlich">
                    <xsl:text>[handschriftlich:] </xsl:text>
                </span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:handShift[@scribe]">
        <xsl:variable name="scribe">
            <xsl:value-of select="@scribe"/>
        </xsl:variable>
        <span class="handschriftlich">
            <xsl:text>[handschriftlich </xsl:text>
            <xsl:value-of select="mam:vorname-vor-nachname(ancestor::tei:TEI/descendant::tei:correspDesc//tei:persName[@ref = $scribe])"/>
            <xsl:text>:] </xsl:text>
        </span>
    </xsl:template>
    <xsl:template match="tei:objectType">
        <!-- VVV -->
        <xsl:choose>
            <xsl:when test="text() != ''">
                <!-- für den Fall, dass Textinhalt, wird einfach dieser ausgegeben -->
                <xsl:value-of select="normalize-space(.)"/>
            </xsl:when>
            <xsl:when test="@ana">
                <xsl:choose>
                    <xsl:when test="@ana = 'fotografie'">
                        <xsl:text>Fotografie</xsl:text>
                    </xsl:when>
                    <xsl:when test="@ana = 'entwurf' and @corresp = 'brief'">
                        <xsl:text>Briefentwurf</xsl:text>
                    </xsl:when>
                    <xsl:when test="@ana = 'entwurf' and @corresp = 'telegramm'">
                        <xsl:text>Telegrammentwurf</xsl:text>
                    </xsl:when>
                    <xsl:when test="@ana = 'bildpostkarte'">
                        <xsl:text>Bildpostkarte</xsl:text>
                    </xsl:when>
                    <xsl:when test="@ana = 'postkarte'">
                        <xsl:text>Postkarte</xsl:text>
                    </xsl:when>
                    <xsl:when test="@ana = 'briefkarte'">
                        <xsl:text>Briefkarte</xsl:text>
                    </xsl:when>
                    <xsl:when test="@ana = 'visitenkarte'">
                        <xsl:text>Visitenkarte</xsl:text>
                    </xsl:when>
                    <xsl:when test="@corresp = 'widmung'">
                        <xsl:choose>
                            <xsl:when test="@ana = 'widmung_vorsatzblatt'">
                                <xsl:text>Widmung am Vorsatzblatt</xsl:text>
                            </xsl:when>
                            <xsl:when test="@ana = 'widmung_titelblatt'">
                                <xsl:text>Widmung am Titelblatt</xsl:text>
                            </xsl:when>
                            <xsl:when test="@ana = 'widmung_schmutztitel'">
                                <xsl:text>Widmung am Schmutztitel</xsl:text>
                            </xsl:when>
                            <xsl:when test="@ana = 'widmung_umschlag'">
                                <xsl:text>Widmung am Umschlag</xsl:text>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            <!-- ab hier ist nurmehr @corresp zu berücksichtigen, alle @ana-Fälle sind erledigt -->
            <xsl:when test="@corresp = 'anderes'">
                <xsl:text>Sonderfall</xsl:text>
            </xsl:when>
            <xsl:when test="@corresp = 'bild'">
                <xsl:text>Bild</xsl:text>
            </xsl:when>
            <xsl:when test="@corresp = 'brief'">
                <xsl:text>Brief</xsl:text>
            </xsl:when>
            <xsl:when test="@corresp = 'karte'">
                <xsl:text>Karte</xsl:text>
            </xsl:when>
            <xsl:when test="@corresp = 'kartenbrief'">
                <xsl:text>Kartenbrief</xsl:text>
            </xsl:when>
            <xsl:when test="@corresp = 'telegramm'">
                <xsl:text>Telegramm</xsl:text>
            </xsl:when>
            <xsl:when test="@corresp = 'umschlag'">
                <xsl:text>Umschlag</xsl:text>
            </xsl:when>
            <xsl:when test="@corresp = 'widmung'">
                <xsl:text>Widmung</xsl:text>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="rsmodal">
        <xsl:param name="modalId" as="xs:string"/>
        <xsl:param name="back" as="node()?"/>
        <div class="modal fade" id="{$modalId}" tabindex="-1" aria-labelledby="{$modalId}" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="exampleModalLongTitle4">Auswahl</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Schließen"/>
                    </div>
                    <div class="modal-body">
                        <ul>
                            <xsl:for-each select="tokenize($modalId, 'pmb')">
                                <xsl:variable name="current" select="concat('pmb', .)" as="xs:string"/>
                                <xsl:if test=". != ''">
                                    <li>
                                        <xsl:variable name="eintrag" select="$back//tei:*[@xml:id = $current][1]" as="node()?"/>
                                        <xsl:variable name="typ" select="$eintrag/name()" as="xs:string?"/>
                                        <xsl:element name="a">
                                            <xsl:attribute name="href">
                                                <xsl:value-of select="concat($current, '.html')"/>
                                            </xsl:attribute>
                                            <xsl:choose>
                                                <xsl:when test="$typ = 'place'">
                                                    <xsl:value-of select="$eintrag/tei:placeName[1]"/>
                                                </xsl:when>
                                                <xsl:when test="$typ = 'bibl'">
                                                    <xsl:value-of select="$eintrag/tei:title[1]"/>
                                                </xsl:when>
                                                <xsl:when test="$typ = 'org'">
                                                    <xsl:value-of select="$eintrag/tei:orgName[1]"/>
                                                </xsl:when>
                                                <xsl:when test="$typ = 'person'">
                                                    <xsl:value-of select="$eintrag/tei:persName[1]"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:text>offen</xsl:text>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:element>
                                    </li>
                                </xsl:if>
                            </xsl:for-each>
                        </ul>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Schließen</button>
                    </div>
                </div>
            </div>
        </div>
    </xsl:template>
    <!-- tei:rs -->
    <!-- erster Fall: alles ganz einfach, keine Verschachtelung, keine note: -->
    <xsl:template match="tei:rs[not(ancestor::tei:note[@type = 'eb' or @type = 'ea']) and not(ancestor::tei:note)][not(ancestor::tei:rs) and not(descendant::tei:rs[not(ancestor::tei:note)]) and not(contains(@ref, ' '))] | tei:persName | tei:author | tei:placeName | tei:orgName">
        <xsl:variable name="entity-typ" as="xs:string">
            <xsl:choose>
                <xsl:when test="@type = 'person'">
                    <xsl:text>persons</xsl:text>
                </xsl:when>
                <xsl:when test="@type = 'work'">
                    <xsl:text>works</xsl:text>
                </xsl:when>
                <xsl:when test="@type = 'place'">
                    <xsl:text>places</xsl:text>
                </xsl:when>
                <xsl:when test="@type = 'letter'">
                    <xsl:text>letters</xsl:text>
                </xsl:when>
                <xsl:when test="@type = 'bible'">
                    <xsl:text>bibles</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>persons</xsl:text>                    <!-- default-Wert Wenn eine Referenz nicht bekannt ist. (Brief L00497.xml)-->
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="js-function-call">
            <xsl:text>displayEntity("</xsl:text>
            <xsl:value-of select="replace(@ref, '#', '')"/>
            <xsl:text>")</xsl:text>
        </xsl:variable>
        <xsl:variable name="link">
            <xsl:if test="@type = 'letter'">
                <xsl:text>./</xsl:text>
                <xsl:value-of select="replace(@ref, '#', '')"/>
                <xsl:text>.html</xsl:text>
            </xsl:if>
            <xsl:if test="not(@type = 'letter')">
                <xsl:text>#</xsl:text>
            </xsl:if>
        </xsl:variable>
        <span>
            <xsl:attribute name="class">
                <xsl:value-of select="$entity-typ"/>
            </xsl:attribute>
            <xsl:element name="a">
                <xsl:attribute name="href">
                    <xsl:value-of select="$link"/>
                </xsl:attribute>
                <xsl:if test="not(@type = 'letter')">
                    <xsl:attribute name="onclick">
                        <xsl:value-of select="$js-function-call"/>
                    </xsl:attribute>
                </xsl:if>
                <xsl:apply-templates/>
            </xsl:element>
        </span>
    </xsl:template>
    <!-- zweiter Fall: rs ist nicht in einem note und hat entweder mehrere Werte im @ref oder einen Nachkommen,
    der ebenfalls ein @ref hat (und auch nicht im note steht) -->
    <xsl:template match="tei:rs[not(ancestor::tei:note) and contains(@ref, ' ') or descendant::tei:rs[not(ancestor::tei:note)]]">
        <xsl:variable name="modalId1" as="xs:string">
            <xsl:value-of select=".//@ref[not(ancestor::tei:note)]"/>
        </xsl:variable>
        <xsl:variable name="modalId">
            <xsl:value-of select="xs:string(replace(replace($modalId1, ' #', ''), '#', ''))"/>
        </xsl:variable>
        <xsl:element name="a">
            <xsl:attribute name="class">
                <xsl:text>reference-black</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="data-bs-toggle">modal</xsl:attribute>
            <xsl:attribute name="data-bs-target">
                <xsl:value-of select="concat('#', $modalId)"/>
            </xsl:attribute>
            <xsl:apply-templates mode="verschachtelteA"/>
            <!-- hier die Sonderregeln für ein solches rs -->
        </xsl:element>
    </xsl:template>
    <!-- Ein rs, das in einem anderen enthalten wird, wird ausgegeben, aber nicht mehr weiter zu einem Link etc. -->
    <xsl:template match="tei_rs" mode="verschachtelteA">
        <xsl:apply-templates/>
    </xsl:template>
    <!-- Nun ein einfaches rs in einer note -->
    <xsl:template match="tei:rs[not(ancestor::tei:note[@type = 'eb' or @type = 'ea']) and ancestor::tei:note][not(ancestor::tei:rs[ancestor::tei:note]) and not(descendant::tei:rs) and not(contains(@ref, ' '))]">
        <xsl:variable name="entity-typ" as="xs:string">
            <xsl:choose>
                <xsl:when test="@type = 'person'">
                    <xsl:text>persons</xsl:text>
                </xsl:when>
                <xsl:when test="@type = 'work'">
                    <xsl:text>works</xsl:text>
                </xsl:when>
                <xsl:when test="@type = 'place'">
                    <xsl:text>places</xsl:text>
                </xsl:when>
                <xsl:when test="@type = 'letter'">
                    <xsl:text>letters</xsl:text>
                </xsl:when>
                <xsl:when test="@type = 'bible'">
                    <xsl:text>bibles</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>persons</xsl:text>                    <!-- default-Wert Wenn eine Referenz nicht bekannt ist. (Brief L00498.xml)-->
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <span>
            <xsl:attribute name="class">
                <xsl:value-of select="$entity-typ"/>
            </xsl:attribute>
            <xsl:element name="a">
                <xsl:attribute name="href">
                    <xsl:if test="contains(@ref, ' ')">
                        <xsl:value-of select="concat('#', replace(@ref, ' ', ''))"/>
                    </xsl:if>
                    <xsl:if test="not(contains(@ref, ' '))">
                        <xsl:value-of select="concat(@xml:id, '.html')"/>
                    </xsl:if>
                </xsl:attribute>
                <xsl:apply-templates/>
            </xsl:element>
        </span>
    </xsl:template>
    <!-- ein verschachteltes rs in note -->
    <xsl:template match="tei:rs[not(ancestor::tei:note[@type = 'eb' or @type = 'ea']) and ancestor::tei:note][contains(@ref, ' ') or descendant::tei:rs]">
        <xsl:variable name="modalId1" as="xs:string">
            <xsl:value-of select=".//@ref"/>
        </xsl:variable>
        <xsl:variable name="modalId">
            <xsl:value-of select="xs:string(replace(replace($modalId1, ' #', ''), '#', ''))"/>
        </xsl:variable>
        <xsl:element name="a">
            <xsl:attribute name="class">
                <xsl:text>reference-black</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="data-bs-toggle">modal</xsl:attribute>
            <xsl:attribute name="data-bs-target">
                <xsl:value-of select="concat('#', $modalId)"/>
            </xsl:attribute>
            <xsl:apply-templates mode="verschachtelteA"/>
            <!-- hier die Sonderregeln für ein solches rs -->
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:rs[not(ancestor::tei:note[@type = 'eb' or @type = 'ea']) and @type = 'work' and not(ancestor::tei:quote) and ancestor::tei:note and not(@subtype = 'implied')]/text()">
        <span class="works {substring-after(@rendition, '#')}" id="{@xml:id}">
            <span class="italics">
                <xsl:value-of select="."/>
            </span>
        </span>
    </xsl:template>
    <xsl:template match="tei:rs[ancestor::tei:note[@type = 'eb' or @type = 'ea'] and not(ancestor::tei:quote) and ancestor::tei:note and not(@subtype = 'implied')]">
        <xsl:if test="@type = 'work'">
            <span class="works">
                <span class="italics">
                    <a>
                        <xsl:attribute name="href">
                            <xsl:value-of select="replace(@ref, '#', '' )"/>
                            <xsl:text>.html</xsl:text>
                        </xsl:attribute>
                        <xsl:apply-templates/>
                    </a>
                </span>
            </span>
        </xsl:if>
        <xsl:if test="@type = 'place'">
            <span class="places">
                <a>
                    <xsl:attribute name="href">
                        <xsl:value-of select="replace(@ref, '#', '' )"/>
                        <xsl:text>.html</xsl:text>
                    </xsl:attribute>
                    <xsl:apply-templates/>
                </a>
            </span>
        </xsl:if>
        <xsl:if test="@type ='person'">
            <span class="persons">
                <a>
                    <xsl:attribute name="href">
                        <xsl:value-of select="replace(@ref, '#', '' )"/>
                        <xsl:text>.html</xsl:text>
                    </xsl:attribute>
                    <xsl:apply-templates/>
                </a>
            </span>
        </xsl:if>
    </xsl:template>    
</xsl:stylesheet>