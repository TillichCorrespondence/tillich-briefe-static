<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:local="http://dse-static.foo.bar" version="2.0" exclude-result-prefixes="xsl tei xs local">
    <xsl:output encoding="UTF-8" media-type="text/html" method="html" version="5.0" indent="yes"
        omit-xml-declaration="yes"/>

    <xsl:import href="./partials/shared.xsl"/>
    <xsl:import href="./partials/entities.xsl"/>
    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="./partials/html_footer.xsl"/>


    <xsl:variable name="prev">
        <xsl:value-of select="replace(tokenize(data(tei:TEI/@prev), '/')[last()], '.xml', '.html')"
        />
    </xsl:variable>
    <xsl:variable name="next">
        <xsl:value-of select="replace(tokenize(data(tei:TEI/@next), '/')[last()], '.xml', '.html')"
        />
    </xsl:variable>
    <xsl:variable name="teiSource">
        <xsl:value-of select="data(tei:TEI/@xml:id)"/>
    </xsl:variable>
    <xsl:variable name="link">
        <xsl:value-of select="replace($teiSource, '.xml', '.html')"/>
    </xsl:variable>
    <xsl:variable name="doc_title">
        <xsl:value-of select=".//tei:titleStmt/tei:title[1]/text()"/>
    </xsl:variable>
    <xsl:variable name="doc-url">
        <xsl:value-of select="concat('https://tillich-briefe.acdh.oeaw.ac.at/', $link)"/>
    </xsl:variable>


    <xsl:template match="/">
        <html class="h-100" lang="de">
            <head>
                <xsl:call-template name="html_head">
                    <xsl:with-param name="html_title" select="$doc_title"/>
                </xsl:call-template>
            </head>

            <body class="d-flex flex-column h-100">
                <xsl:call-template name="nav_bar"/>
                <main class="flex-shrink-0 flex-grow-1">
                    <nav style="--bs-breadcrumb-divider: '>';" aria-label="breadcrumb"
                        class="ps-5 p-3">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item">
                                <a href="index.html">Tillich-Briefe</a>
                            </li>
                            <li class="breadcrumb-item">
                                <a href="toc.html">Alle Briefe</a>
                            </li>
                        </ol>
                    </nav>
                    <div class="container">
                        <div class="row">
                            <div class="col-md-2 col-lg-2 col-sm-12 text-start">
                                <xsl:if test="ends-with($prev, '.html')">
                                    <a>
                                        <xsl:attribute name="href">
                                            <xsl:value-of select="$prev"/>
                                        </xsl:attribute>
                                        <i class="fs-2 bi bi-chevron-left"
                                            title="Zurück zum vorigen Dokument"
                                            visually-hidden="true">
                                            <span class="visually-hidden">Zurück zum vorigen
                                                Dokument</span>
                                        </i>
                                    </a>
                                </xsl:if>
                            </div>
                            <div class="col-md-8 col-lg-8 col-sm-12 text-center">
                                <h1>
                                    <xsl:value-of select="$doc_title"/>
                                </h1>
                                <div>
                                    <a href="{$teiSource}">
                                        <i class="bi bi-download fs-2" title="Zum TEI/XML Dokument"
                                            visually-hidden="true">
                                            <span class="visually-hidden">Zum TEI/XML
                                                Dokument</span>
                                        </i>
                                    </a>
                                </div>
                            </div>
                            <div class="col-md-2 col-lg-2 col-sm-12 text-end">
                                <xsl:if test="ends-with($next, '.html')">
                                    <a>
                                        <xsl:attribute name="href">
                                            <xsl:value-of select="$next"/>
                                        </xsl:attribute>
                                        <i class="fs-2 bi bi-chevron-right"
                                            title="Weiter zum nächsten Dokument"
                                            visually-hidden="true">
                                            <span class="visually-hidden">Weiter zum nächsten
                                                Dokument</span>
                                        </i>
                                    </a>
                                </xsl:if>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-6">
                                <div>
                                    <h2 class="visually-hidden">Der editierte Text</h2>
                                    <xsl:apply-templates select=".//tei:body"/>
                                </div>
                                <hr/>
                                <div class="pt-3">
                                    <h2 class="visually-hidden">Fußnoten, Anmerkungen</h2>
                                    <div class="ps-5 pe-5">
                                        <xsl:for-each select=".//tei:note[@type='ea']">
                                            <div class="footnotes" id="{local:makeId(.)}">
                                                <xsl:element name="a">
                                                    <xsl:attribute name="name">
                                                        <xsl:text>fn</xsl:text>
                                                        <xsl:number level="any" format="1" count="tei:note"
                                                        />
                                                    </xsl:attribute>
                                                    <a>
                                                        <xsl:attribute name="href">
                                                            <xsl:text>#fna_</xsl:text>
                                                            <xsl:number level="any" format="1"
                                                                count="tei:note"/>
                                                        </xsl:attribute>
                                                        <span
                                                            style="font-size:7pt;vertical-align:super; margin-right: 0.4em">
                                                            <xsl:number level="any" format="1"
                                                                count="tei:note"/>
                                                        </span>
                                                    </a>
                                                </xsl:element>
                                                <xsl:apply-templates/>
                                            </div>
                                        </xsl:for-each>
                                    </div>
                                </div>
                            </div>
                            <div class="col-lg-1"/>
                            <div class="col-lg-5">
                                <div>
                                    <h2 class="fs-3">Überlieferung</h2>
                                    <dl>
                                        <dt>Signatur</dt>
                                        <dd>
                                            <xsl:value-of select="string-join(.//tei:msIdentifier/tei:*/text(), ', ')"/>
                                        </dd>
                                        
                                        <dt>Typ</dt>
                                        <dd><xsl:apply-templates select=".//tei:physDesc"></xsl:apply-templates></dd>
                                        <dt>Postweg</dt>
                                        <dd>
                                            <xsl:choose>
                                                <xsl:when test=".//tei:correspAction[@type='sent']/tei:placeName/text()">
                                                    <xsl:value-of select="string-join(.//tei:correspAction[@type='sent']/tei:placeName/text(), '; ')"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    unbekannt
                                                </xsl:otherwise>
                                            </xsl:choose>
                                            -
                                            <xsl:choose>
                                                <xsl:when test=".//tei:correspAction[@type='received']/tei:placeName/text()">
                                                    <xsl:value-of select="string-join(.//tei:correspAction[@type='received']/tei:placeName/text(), '; ')"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    unbekannt
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </dd>
                                        <xsl:if test=".//tei:ref[@subtype='previous_letter' and @type='withinCorrespondence']">
                                            <dt>voriger Brief in der Korrespondenz</dt>
                                            <dd>
                                                <a href="{replace(.//tei:ref[@subtype='previous_letter' and @type='withinCorrespondence']/@target, '.xml', '.html')}">
                                                    <xsl:value-of select=".//tei:ref[@subtype='previous_letter' and @type='withinCorrespondence']/text()"/>
                                                </a>
                                            </dd>
                                        </xsl:if>
                                        <xsl:if test=".//tei:ref[@subtype='next_letter' and @type='withinCorrespondence']">
                                            <dt>nächster Brief in der Korrespondenz</dt>
                                            <dd>
                                                <a href="{replace(.//tei:ref[@subtype='next_letter' and @type='withinCorrespondence']/@target, '.xml', '.html')}">
                                                    <xsl:value-of select=".//tei:ref[@subtype='next_letter' and @type='withinCorrespondence']/text()"/>
                                                </a>
                                            </dd>
                                        </xsl:if>
                                    </dl>
                                    <hr />
                                </div>
                                <h2 class="visually-hidden">Entitäten</h2>
                                <xsl:if test=".//tei:back//tei:person[@xml:id]">
                                    <div>
                                        <h3 class="fs-4 p-1">Personen</h3>

                                        <div class="ps-4">
                                            <xsl:for-each select=".//tei:back//tei:person[@xml:id]">
                                                <div class="form-check">
                                                  <input class="form-check-input" type="checkbox"
                                                  onchange="toggleHighlight(this)"
                                                  value="{@xml:id}" id="check-{@xml:id}"/>
                                                  <label class="form-check-label" for="check-{@xml:id}">
                                                  <xsl:value-of select="./tei:persName[1]/text()"/>
                                                  </label>
                                                </div>
                                            </xsl:for-each>
                                        </div>
                                    </div>
                                </xsl:if>

                                <xsl:if test=".//tei:back//tei:place[@xml:id]">
                                    <div>
                                        <h3 class="fs-4 p-1">Orte</h3>
                                        <div class="ps-4">
                                            <xsl:for-each select=".//tei:back//tei:place[@xml:id]">
                                                <div class="form-check">
                                                    <input class="form-check-input" type="checkbox"
                                                        onchange="toggleHighlight(this)"
                                                        value="{@xml:id}" id="check-{@xml:id}"/>
                                                    <label class="form-check-label" for="check-{@xml:id}">
                                                        <xsl:value-of select="./tei:placeName[1]/text()"/>
                                                    </label>
                                                </div>
                                            </xsl:for-each>
                                        </div>
                                    </div>
                                </xsl:if>
                                <xsl:if test=".//tei:back//tei:biblStruct[@xml:id]">
                                    <div>
                                        <h3 class="fs-4 p-1">Literatur</h3>
                                        
                                        <div class="ps-4">
                                            <xsl:for-each
                                                select=".//tei:back//tei:biblStruct[@xml:id]">
                                                <div class="form-check">
                                                    <input class="form-check-input" type="checkbox"
                                                        onchange="toggleHighlight(this)"
                                                        value="{@xml:id}" id="check-{@xml:id}"/>
                                                    <label class="form-check-label" for="check-{@xml:id}">
                                                        <xsl:value-of select="./@n"/>
                                                    </label>
                                                </div>
                                            </xsl:for-each>
                                        </div>
                                    </div>
                                </xsl:if>
                                <xsl:if test=".//tei:rs[@type='bible' and @ref]">
                                    <div>
                                        <h3 class="fs-4 p-1">Bibelstellen</h3>
                                        <div class="ps-4">
                                            <xsl:for-each
                                                select="distinct-values(.//tei:rs[@type='bible' and @ref]/@ref)">
                                                <xsl:variable name="biblId">
                                                    <xsl:value-of select="lower-case(replace(replace(., ',', '-'), ' ', ''))"/>
                                                </xsl:variable>
                                                <div class="form-check">
                                                    <input class="form-check-input" type="checkbox"
                                                        onchange="toggleHighlight(this)"
                                                        value="{$biblId}" id="check-{$biblId}"/>
                                                    <label class="form-check-label" for="check-{$biblId}">
                                                        <xsl:value-of select="."/>
                                                    </label>
                                                </div>
                                            </xsl:for-each>
                                        </div>
                                    </div>
                                </xsl:if>
                                <xsl:if test=".//tei:list[@xml:id = 'mentioned_letters']">
                                    <div>
                                        <h3 class="fs-4 p-1">Briefe</h3>
                                        <div class="ps-4">
                                            <xsl:for-each
                                                select=".//tei:list[@xml:id = 'mentioned_letters']//tei:item[@xml:id]">
                                                <div class="form-check">
                                                    <input class="form-check-input" type="checkbox"
                                                        onchange="toggleHighlight(this)"
                                                        value="{@xml:id}" id="check-{@xml:id}"/>
                                                    <label class="form-check-label" for="check-{@xml:id}">
                                                        <xsl:value-of select="./text()"/>
                                                    </label>
                                                </div>
                                            </xsl:for-each>
                                        </div>
                                    </div>
                                </xsl:if>
                                
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-2"/>
                            <div class="col-md-8">
                                <h2 class="text-center p-3 fs-3">Zitiervorschlag</h2>
                                <blockquote class="blockquote">
                                    <xsl:value-of select=".//tei:titleStmt/tei:title[1]/text()"/>
                                    <xsl:text>, in: Paul Tillich, Korrespondenz. Digitale Edition, hg. von Christian Danz und Friedrich Wilhelm Graf. </xsl:text>
                                    <xsl:value-of select="$doc-url"/>
                                    <xsl:text>, Zugriff am </xsl:text>
                                    <span class="currentDate">????</span>
                                    <xsl:text>.</xsl:text>
                                </blockquote>
                                <h3 class="text-center p-3 fs-4">
                                    Für Belege in der Wikipedia
                                </h3>
                                <blockquote>
                                    <code>
                                        {{Internetquelle |url=<xsl:value-of select="$doc-url"/>
                                        <xsl:text> |titel=</xsl:text>
                                        <xsl:value-of select=".//tei:titleStmt/tei:title[1]"/>
                                        <xsl:text> |werk=Paul Tillich, Korrespondenz. Digitale Edition. |hrsg=Christian Danz, Friedrich Wilhelm Graf |sprache=de |  datum=</xsl:text>
                                        <xsl:value-of select="//tei:correspAction[@type = 'sent']/tei:date[@when]"/>
                                        <xsl:text> |abruf=</xsl:text>
                                        <span class="currentDateYYYYMMDD">????</span>
                                        <xsl:text> }}</xsl:text>
                                    </code>
                                </blockquote>
                            </div>
                            <div class="col-md-2"/>
                        </div>
                        
                    </div>
                    <xsl:for-each select="//tei:back">
                        <div class="tei-back pt-3">
                            <xsl:apply-templates/>
                        </div>
                    </xsl:for-each>
                    
                </main>
                <xsl:call-template name="html_footer"/>
                <script src="js/main.js"></script>
            </body>

        </html>
    </xsl:template>
    <xsl:template match="tei:pb">
        <xsl:element name="span">
            <xsl:attribute name="class">pagebreak</xsl:attribute>
            <xsl:attribute name="title">Seitenbeginn, S. <xsl:value-of select="data(@n)"/>
            </xsl:attribute>
            <xsl:text>|
            </xsl:text>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:dateline">
        <div class="text-end">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="tei:salute">
        <div class="text-start pb-2">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    <xsl:template match="tei:choice[./tei:abbr and ./tei:expan]">
    <abbr title="{./tei:expan/text()}">
        <xsl:apply-templates select="./tei:abbr"/>
    </abbr>
    </xsl:template>
    
    <xsl:template match="tei:list/tei:head"/>
    
    <xsl:template match="tei:unclear">
        <xsl:text>[</xsl:text><xsl:apply-templates/><xsl:text>]</xsl:text>
    </xsl:template>
</xsl:stylesheet>
