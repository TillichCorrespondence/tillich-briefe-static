<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:mam="whatever" version="2.0" exclude-result-prefixes="xsl tei xs">
    <xsl:import href="./LOD-idnos.xsl"/>
    <xsl:param name="places" select="document('../../data/indices/listplace.xml')"/>
    <xsl:param name="works" select="document('../../data/indices/listwork.xml')"/>
    <xsl:key name="work-lookup" match="tei:bibl" use="tei:relatedItem/@target"/>
    <xsl:key name="only-relevant-uris" match="item" use="abbr"/>
    <xsl:key name="authorwork-lookup" match="tei:bibl" use="tei:author/@*[name() = 'key' or name() = 'ref']/replace(replace(., 'person__', ''), 'pmb', '')"/>
    <!-- PERSON -->
    <xsl:template match="tei:person" name="person_detail">
        <xsl:param name="showNumberOfMentions" as="xs:integer" select="50000"/>
        <xsl:variable name="selfLink">
            <xsl:value-of select="concat(data(@xml:id), '.html')"/>
        </xsl:variable>
        <div class="card-body-index">
            <xsl:variable name="lemma-name" select="tei:persName[(position() = 1)]" as="node()"/>
            <xsl:variable name="namensformen" as="node()">
                <xsl:element name="listPerson">
                    <xsl:for-each select="descendant::tei:persName[not(position() = 1)]">
                        <xsl:copy-of select="."/>
                    </xsl:for-each>
                </xsl:element>
            </xsl:variable>
            <div id="mentions">
                <!--  <xsl:if test="key('only-relevant-uris', tei:idno/@subtype, $relevant-uris)[1]"> -->
                <p class="buttonreihe">
                    <xsl:variable name="idnos-of-current" as="node()">
                        <xsl:element name="nodeset_person">
                            <xsl:for-each select="tei:idno">
                                <xsl:copy-of select="."/>
                            </xsl:for-each>
                        </xsl:element>
                    </xsl:variable>
                    <xsl:call-template name="mam:idnosToLinks">
                        <xsl:with-param name="idnos-of-current" select="$idnos-of-current"/>
                    </xsl:call-template>
                </p>
                <!-- </xsl:if> -->
            </div>
            <div class="WikimediaContainer">
                <xsl:if test=".//tei:occupation">
                    <p>
                        <xsl:text>Beruf: </xsl:text>
                        <xsl:value-of select="tei:occupation"/>
                    </p>
                </xsl:if>
                <xsl:if test=".//tei:note[@type = 'bio']">
                    <p>
                        <xsl:text>Biografische Notiz: </xsl:text>
                        <xsl:value-of select="tei:note"/>
                    </p>
                </xsl:if>
            </div>
            <xsl:if test=".//tei:note[@type = 'mentions']">
                <div id="mentions" class="mt-2">
                    <span class="infodesc mr-2">
                        <ul>
                            <legend>Erwähnungen</legend>
                            <xsl:for-each select=".//tei:note[@type = 'mentions']">
                                <xsl:sort select="replace(@corresp, '-', '')" order="ascending" data-type="number"/>
                                <xsl:variable name="linkToDocument">
                                    <xsl:value-of select="replace(tokenize(data(.//@target), '/')[last()], '.xml', '.html')" />
                                </xsl:variable>
                                <xsl:choose>
                                    <xsl:when test="position() lt $showNumberOfMentions + 1">
                                        <li>
                                            <xsl:value-of select="."/>
                                            <xsl:text></xsl:text>
                                            <a href="{$linkToDocument}">
                                                <i class="fas fa-external-link-alt"/>
                                            </a>
                                        </li>
                                    </xsl:when>
                                </xsl:choose>
                            </xsl:for-each>
                        </ul>
                        <xsl:if test="count(.//tei:note[@type = 'mentions']) gt $showNumberOfMentions + 1">
                            <p>Anzahl der Erwähnungen limitiert, klicke <a href="{$selfLink}">hier</a>
                            für eine vollständige Auflistung</p>
                        </xsl:if>
                    </span>
                </div>
            </xsl:if>
        </div>
    </xsl:template>
    <!-- WORK -->
    <xsl:template match="tei:listBibl/tei:bibl" name="work_detail">
        <xsl:param name="showNumberOfMentions" as="xs:integer" select="50000"/>
        <xsl:variable name="selfLink">
            <xsl:value-of select="concat(data(@xml:id), '.html')"/>
        </xsl:variable>
        <div class="card-body-index">
            <div id="mentions">
                <xsl:if test="key('only-relevant-uris', tei:idno/@subtype, $relevant-uris)[1]">
                    <p class="buttonreihe">
                        <xsl:variable name="idnos-of-current" as="node()">
                            <xsl:element name="nodeset_work">
                                <xsl:for-each select="tei:idno">
                                    <xsl:copy-of select="."/>
                                </xsl:for-each>
                            </xsl:element>
                        </xsl:variable>
                        <xsl:call-template name="mam:idnosToLinks">
                            <xsl:with-param name="idnos-of-current" select="$idnos-of-current"/>
                        </xsl:call-template>
                    </p>
                </xsl:if>
            </div>
            <xsl:if test="tei:author">
                <div id="autor_innen">
                    <xsl:choose>
                        <xsl:when test="tei:author[2]">
                            <ul>
                                <legend>Geschaffen von</legend>
                                <xsl:for-each select="tei:author">
                                    <li>
                                        <xsl:variable name="keyToRef" as="xs:string">
                                            <xsl:choose>
                                                <xsl:when test="@key != ''">
                                                    <xsl:value-of select="@key"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="@ref"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:variable>
                                        <xsl:variable name="autor-ref" as="xs:string">
                                            <xsl:choose>
                                                <xsl:when test="contains($keyToRef, 'person__')">
                                                    <xsl:value-of select="concat('pmb', substring-after($keyToRef, 'person__'))" />
                                                </xsl:when>
                                                <xsl:when test="starts-with($keyToRef, 'pmb')">
                                                    <xsl:value-of select="$keyToRef"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="concat('pmb', $keyToRef)"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:variable>
                                        <xsl:choose>
                                            <xsl:when test="$autor-ref = 'pmb2121'">
                                                <a href="pmb2121.html">
                                                    <xsl:text>Arthur Schnitzler</xsl:text>
                                                </a>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <a>
                                                    <xsl:attribute name="href">
                                                        <xsl:value-of select="concat($autor-ref, '.html')" />
                                                    </xsl:attribute>
                                                    <xsl:choose>
                                                        <xsl:when test="child::tei:forename and child::tei:surname">
                                                            <xsl:value-of select="tei:persName/tei:forename"/>
                                                            <xsl:text></xsl:text>
                                                            <xsl:value-of select="tei:persName/tei:surname"/>
                                                        </xsl:when>
                                                        <xsl:when test="child::tei:surname">
                                                            <xsl:value-of select="child::tei:surname"/>
                                                        </xsl:when>
                                                        <xsl:when test="child::tei:forename">
                                                            <xsl:value-of select="child::tei:forename"/>
"/>                                                        </xsl:when>
                                                        <xsl:when test="contains(., ', ')">
                                                            <xsl:value-of select="concat(substring-after(., ', '), ' ', substring-before(., ', '))" />
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                            <xsl:value-of select="."/>
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                </a>
                                                <xsl:choose>
                                                    <xsl:when test="@role = 'editor' or @role = 'hat-herausgegeben'">
                                                        <xsl:text> (Herausgabe)</xsl:text>
                                                    </xsl:when>
                                                    <xsl:when test="@role = 'translator' or @role = 'hat-ubersetzt'">
                                                        <xsl:text> (Übersetzung)</xsl:text>
                                                    </xsl:when>
                                                    <xsl:when test="@role = 'hat-ubersetzt'">
                                                        <xsl:text> (unter Pseudonym)</xsl:text>
                                                    </xsl:when>
                                                    <xsl:when test="@role = 'hat-unter-einem-kurzel-veroffentlicht'">
                                                        <xsl:text> (unter Kürzel)</xsl:text>
                                                    </xsl:when>
                                                    <xsl:when test="@role = 'hat-illustriert'">
                                                        <xsl:text> (Illustration)</xsl:text>
                                                    </xsl:when>
                                                    <xsl:when test="@role = 'hat-vertont'">
                                                        <xsl:text> (Vertonung)</xsl:text>
                                                    </xsl:when>
                                                    <xsl:when test="@role = 'hat-einen-beitrag-geschaffen-zu'">
                                                        <xsl:text> (Beitrag)</xsl:text>
                                                    </xsl:when>
                                                    <xsl:when test="@role = 'hat-ein-vorwortnachwort-verfasst-zu'">
                                                        <xsl:text> (Vorwort/Nachwort)</xsl:text>
                                                    </xsl:when>
                                                    <xsl:when test="@role = 'hat-anonym-veroffentlicht'">
                                                        <xsl:text> (ohne Namensnennung)</xsl:text>
                                                    </xsl:when>
                                                    <xsl:when test="@role = 'bekommt-zugeschrieben'">
                                                        <xsl:text> (Zuschreibung)</xsl:text>
                                                    </xsl:when>
                                                </xsl:choose>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </li>
                                </xsl:for-each>
                            </ul>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:variable name="keyToRef" as="xs:string">
                                <xsl:choose>
                                    <xsl:when test="tei:author/@key != ''">
                                        <xsl:value-of select="tei:author/@key"/>
                                    </xsl:when>
                                    <xsl:when test="tei:author/@ref != ''">
                                        <xsl:value-of select="tei:author/@ref"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:text>SELTSAM</xsl:text>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable>
                            <xsl:variable name="autor-ref" as="xs:string">
                                <xsl:choose>
                                    <xsl:when test="contains($keyToRef, 'person__')">
                                        <xsl:value-of select="concat('pmb', substring-after($keyToRef, 'person__'))" />
                                    </xsl:when>
                                    <xsl:when test="starts-with($keyToRef, 'pmb')">
                                        <xsl:value-of select="$keyToRef"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="concat('pmb', $keyToRef)"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable>
                            <xsl:choose>
                                <xsl:when test="$autor-ref = 'pmb2121'">
                                    <a href="pmb2121.html">
                                        <xsl:text>Arthur Schnitzler</xsl:text>
                                    </a>
                                </xsl:when>
                                <xsl:otherwise>
                                    <a>
                                        <xsl:attribute name="href">
                                            <xsl:value-of select="concat($autor-ref, '.html')"/>
                                        </xsl:attribute>
                                        <xsl:choose>
                                            <xsl:when test="child::tei:forename and child::tei:surname">
                                                <xsl:value-of select="tei:persName/tei:forename"/>
                                                <xsl:text></xsl:text>
                                                <xsl:value-of select="tei:persName/tei:surname"/>
                                            </xsl:when>
                                            <xsl:when test="child::tei:surname">
                                                <xsl:value-of select="child::tei:surname"/>
                                            </xsl:when>
                                            <xsl:when test="child::tei:forename">
                                                <xsl:value-of select="child::tei:forename"/>
"/>                                            </xsl:when>
                                            <xsl:when test="contains(., ', ')">
                                                <xsl:value-of select="concat(substring-after(tei:author[1], ', '), ' ', substring-before(tei:author[1], ', '))" />
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="tei:author[1]"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </a>
                                    <xsl:if test="@role = 'editor'">
                                        <xsl:text> (Herausgabe)</xsl:text>
                                    </xsl:if>
                                    <xsl:if test="@role = 'translator'">
                                        <xsl:text> (Übersetzung)</xsl:text>
                                    </xsl:if>
                                    <xsl:if test="@role = 'illustrator'">
                                        <xsl:text> (Illustration)</xsl:text>
                                    </xsl:if>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:otherwise>
                    </xsl:choose>
                </div>
                <div id="erscheinungsdatum" class="mt-2">
                    <p>
                        <xsl:if test="tei:date[1]">
                            <ul>
                                <legend>Erschienen</legend>
                                <li>
                                    <xsl:choose>
                                        <xsl:when test="contains(tei:date[1], '-')">
                                            <xsl:choose>
                                                <xsl:when test="normalize-space(tokenize(tei:date[1], '-')[1]) = normalize-space(tokenize(tei:date[1], '-')[2])">
                                                    <xsl:value-of select="mam:normalize-date(normalize-space((tokenize(tei:date[1], '-')[1])))" />
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="mam:normalize-date(normalize-space(tei:date[1]))" />
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="mam:normalize-date(tei:date[1])"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                    <xsl:if test="not(ends-with(tei:date[1], '.'))">
                                        <xsl:text>.</xsl:text>
                                    </xsl:if>
                                </li>
                            </ul>
                        </xsl:if>
                    </p>
                </div>
                <p/>
            </xsl:if>
            <xsl:if test="tei:title[@type = 'werk_bibliografische-angabe' or starts-with(@type, 'werk_link')]">
                <div id="labels" class="mt-2">
                    <span class="infodesc mr-2">
                        <ul>
                            <xsl:for-each select="tei:title[@type = 'werk_bibliografische-angabe']">
                                <li>
                                    <xsl:text>Bibliografische Angabe: </xsl:text>
                                    <xsl:value-of select="."/>
                                </li>
                            </xsl:for-each>
                            <xsl:for-each select="tei:title[starts-with(@type, 'werk_link')]">
                                <li>
                                    <a>
                                        <xsl:attribute name="href">
                                            <xsl:value-of select="."/>
                                        </xsl:attribute>
                                        <xsl:attribute name="target">
                                            <xsl:text>_blank</xsl:text>
                                        </xsl:attribute>
                                        <xsl:text>Online verfügbar</xsl:text>
                                    </a>
                                </li>
                            </xsl:for-each>
                        </ul>
                    </span>
                </div>
            </xsl:if>
            <xsl:if test="tei:note[@type = 'mentions']">
                <div id="mentions" class="mt-2">
                    <span class="infodesc mr-2">
                        <ul>
                            <legend>Erwähnungen</legend>
                            <xsl:for-each select=".//tei:note[@type = 'mentions']">
                                <xsl:sort select="replace(@corresp, '-', '')" order="ascending" data-type="number"/>
                                <xsl:variable name="linkToDocument">
                                    <xsl:value-of select="replace(tokenize(data(.//@target), '/')[last()], '.xml', '.html')" />
                                </xsl:variable>
                                <xsl:choose>
                                    <xsl:when test="position() lt $showNumberOfMentions + 1">
                                        <li>
                                            <xsl:value-of select="."/>
                                            <xsl:text></xsl:text>
                                            <a href="{$linkToDocument}">
                                                <i class="fas fa-external-link-alt"/>
                                            </a>
                                        </li>
                                    </xsl:when>
                                </xsl:choose>
                            </xsl:for-each>
                        </ul>
                        <xsl:if test="count(.//tei:note[@type = 'mentions']) gt $showNumberOfMentions + 1">
                            <p>Anzahl der Erwähnungen limitiert, klicke <a href="{$selfLink}">hier</a>
                            für eine vollständige Auflistung</p>
                        </xsl:if>
                    </span>
                </div>
            </xsl:if>
        </div>
    </xsl:template>
    <!-- PLACE -->
    <xsl:template match="tei:place" name="place_detail">
        <xsl:param name="showNumberOfMentions" as="xs:integer" select="50000"/>
        <xsl:variable name="selfLink">
            <xsl:value-of select="concat(data(@xml:id), '.html')"/>
        </xsl:variable>
        <div class="container-fluid">
            <div class="card-body-index">
                <xsl:if test=".//tei:geo/text()">
                    <div id="mapid" style="height: 400px; width:100%; clear: both;"/>
                    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.7.1/dist/leaflet.css" integrity="sha512-xodZBNTC5n17Xt2atTPuE1HxjVMSvLVW9ocqUKLsCC5CXdbqCmblAshOMAS6/keqq/sMZMZ19scR4PsZChSR7A==" crossorigin=""/>
                    <script src="https://unpkg.com/leaflet@1.7.1/dist/leaflet.js" integrity="sha512-XQoYMqMTK8LvdxXYG3nZ448hOEQiglfqkJs1NOQV44cWnUrBc8PkAOcXy20w0vlaXaVUearIOBhiXZ5V3ynxwA==" crossorigin=""/>
                    <script>
                        
                        var mymap = L.map('mapid').setView([50, 12], 5);
                        
                        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                        attribution: 'Map data &amp;copy; <a href="https://www.openstreetmap.org/">OpenStreetMap</a> contributors, <a href="https://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="https://www.openstreetmap.org/">OpenStreetMap</a>',
                        maxZoom: 18,
                        zIndex: 1
                        }).addTo(mymap);
                        <xsl:variable name="laenge" as="xs:string" select="replace(tokenize(descendant::tei:geo[1]/text(), ' ')[1], ',', '.')"/>
                        <xsl:variable name="breite" as="xs:string" select="replace(tokenize(descendant::tei:geo[1]/text(), ' ')[2], ',', '.')"/>
                        <xsl:variable name="laengebreite" as="xs:string" select="concat($laenge, ', ', $breite)"/>
                        <xsl:value-of select="$laengebreite"/>
                        L.marker([<xsl:value-of select="$laengebreite"/>
]).addTo(mymap)
                        .bindPopup("<b>
                    <xsl:value-of select="./tei:placeName[1]/text()"/>
                </b>").openPopup();
            </script>
            <div class="card"></div>
        </xsl:if>
        <div id="information">
            <xsl:if test=".//tei:location">
                <p>
                    <xsl:text>Koordinaten: </xsl:text>
                    <xsl:value-of select=".//tei:location/tei:geo"/>
                </p>
            </xsl:if>
            <xsl:if test=".//tei:idno[@type = 'geonames']">
                <p>
                    <xsl:text>Geonames: </xsl:text>
                    <a>
                        <xsl:attribute name="href">
                            <xsl:value-of select=".//tei:idno[@type = 'geonames']"/>
                        </xsl:attribute>
                        <xsl:value-of select=".//tei:idno[@type = 'geonames']"/>
                    </a>
                </p>
            </xsl:if>
            <xsl:if test=".//tei:idno[@type = 'wikidata']">
                <p>
                    <xsl:text>Wikidata: </xsl:text>
                    <a>
                        <xsl:attribute name="href">
                            <xsl:value-of select=".//tei:idno[@type = 'wikidata']"/>
                        </xsl:attribute>
                        <xsl:value-of select=".//tei:idno[@type = 'wikidata']"/>
                    </a>
                </p>
            </xsl:if>

        </div>
        <xsl:if test=".//tei:note[@type = 'mentions']">
            <div id="mentions" class="mt-2">
                <span class="infodesc mr-2">
                    <ul>
                        <legend>Erwähnungen</legend>
                        <xsl:for-each select=".//tei:note[@type = 'mentions']">
                            <xsl:sort select="replace(@corresp, '-', '')" order="ascending" data-type="number"/>
                            <xsl:variable name="linkToDocument">
                                <xsl:value-of select="replace(tokenize(data(.//@target), '/')[last()], '.xml', '.html')" />
                            </xsl:variable>
                            <xsl:choose>
                                <xsl:when test="position() lt $showNumberOfMentions + 1">
                                    <li>
                                        <xsl:value-of select="."/>
                                        <xsl:text></xsl:text>
                                        <a href="{$linkToDocument}">
                                            <i class="fas fa-external-link-alt"/>
                                        </a>
                                    </li>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:for-each>
                    </ul>
                    <xsl:if test="count(.//tei:note[@type = 'mentions']) gt $showNumberOfMentions + 1">
                        <p>Anzahl der Erwähnungen limitiert, klicke <a href="{$selfLink}">hier</a> für eine vollständige Auflistung</p>
                    </xsl:if>
                </span>
            </div>
        </xsl:if>
    </div>
</div>
</xsl:template>
<xsl:function name="mam:pmbChange">
<xsl:param name="url" as="xs:string"/>
<xsl:param name="entitytyp" as="xs:string"/>
<xsl:value-of select="
                concat('https://pmb.acdh.oeaw.ac.at/apis/entities/entity/', $entitytyp, '/',
                substring-after($url, 'https://pmb.acdh.oeaw.ac.at/entity/'), '/detail')"/>
</xsl:function>
<!-- ORG -->
<xsl:key name="place-lookup" match="tei:place" use="@xml:id"/>
<xsl:template match="tei:org" name="org_detail">
<xsl:param name="showNumberOfMentions" as="xs:integer" select="50000"/>
<xsl:variable name="selfLink">
    <xsl:value-of select="concat(data(@xml:id), '.html')"/>
</xsl:variable>
<div class="card-body-index">
    <div id="mentions">
        <xsl:if test="key('only-relevant-uris', tei:idno/@subtype, $relevant-uris)[1]">
            <p class="buttonreihe">
                <xsl:variable name="idnos-of-current" as="node()">
                    <xsl:element name="nodeset_org">
                        <xsl:for-each select="tei:idno">
                            <xsl:copy-of select="."/>
                        </xsl:for-each>
                    </xsl:element>
                </xsl:variable>
                <xsl:call-template name="mam:idnosToLinks">
                    <xsl:with-param name="idnos-of-current" select="$idnos-of-current"/>
                </xsl:call-template>
            </p>
        </xsl:if>
    </div>
    <xsl:variable name="ersterName" select="tei:orgName[1]"/>
    <xsl:if test="tei:orgName[2]">
        <p>
            <xsl:for-each select="distinct-values(tei:orgName[@type = 'ort_alternative-name'])">
                <xsl:if test=". != $ersterName">
                    <xsl:value-of select="."/>
                </xsl:if>
                <xsl:if test="not(position() = last())">
                    <xsl:text>, </xsl:text>
                </xsl:if>
            </xsl:for-each>
        </p>
    </xsl:if>
    <xsl:if test="tei:location">
        <div>
            <ul>
                <legend>Orte</legend>
                <li>
                    <xsl:for-each select="tei:location/tei:placeName[not(. = preceding-sibling::tei:placeName)]">
                        <xsl:variable name="key-or-ref" as="xs:string?">
                            <xsl:value-of select="concat(replace(@key, 'place__', 'pmb'), replace(@ref, 'place__', 'pmb'))" />
                        </xsl:variable>
                        <xsl:choose>
                            <xsl:when test="key('place-lookup', $key-or-ref, $places)">
                                <xsl:element name="a">
                                    <xsl:attribute name="href">
                                        <xsl:value-of select="concat($key-or-ref, '.html')" />
                                    </xsl:attribute>
                                    <xsl:value-of select="."/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="."/>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:if test="not(position() = last())">
                            <xsl:text>, </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </li>
            </ul>
        </div>
    </xsl:if>
    <div id="mentions" class="mt-2">
        <span class="infodesc mr-2">
            <ul>
                <legend>Erwähnungen</legend>
                <xsl:for-each select=".//tei:note[@type = 'mentions']">
                    <xsl:sort select="replace(@corresp, '-', '')" order="ascending" data-type="number"/>
                    <xsl:variable name="linkToDocument">
                        <xsl:value-of select="replace(tokenize(data(.//@target), '/')[last()], '.xml', '.html')" />
                    </xsl:variable>
                    <xsl:choose>
                        <xsl:when test="position() lt $showNumberOfMentions + 1">
                            <li>
                                <xsl:value-of select="."/>
                                <xsl:text></xsl:text>
                                <a href="{$linkToDocument}">
                                    <i class="fas fa-external-link-alt"/>
                                </a>
                            </li>
                        </xsl:when>
                    </xsl:choose>
                </xsl:for-each>
            </ul>
            <xsl:if test="count(.//tei:note[@type = 'mentions']) gt $showNumberOfMentions + 1">
                <p>Anzahl der Erwähnungen limitiert, klicke <a href="{$selfLink}">hier</a>
                            für eine vollständige Auflistung</p>
            </xsl:if>
        </span>
    </div>
</div>
</xsl:template>
<xsl:function name="mam:ahref-namen">
<xsl:param name="typityp" as="xs:string"/>
<xsl:choose>
    <xsl:when test="$typityp = 'schnitzler-tagebuch'">
        <xsl:text> Tagebuch</xsl:text>
    </xsl:when>
    <xsl:when test="$typityp = 'schnitzler-briefe'">
        <xsl:text> Briefe</xsl:text>
    </xsl:when>
    <xsl:when test="$typityp = 'schnitzler-lektueren'">
        <xsl:text> Lektüren</xsl:text>
    </xsl:when>
    <xsl:when test="$typityp = 'PMB'">
        <xsl:text> PMB</xsl:text>
    </xsl:when>
    <xsl:when test="$typityp = 'pmb'">
        <xsl:text> PMB</xsl:text>
    </xsl:when>
    <xsl:when test="$typityp = 'briefe_i'">
        <xsl:text> Briefe 1875–1912</xsl:text>
    </xsl:when>
    <xsl:when test="$typityp = 'briefe_ii'">
        <xsl:text> Briefe 1913–1931</xsl:text>
    </xsl:when>
    <xsl:when test="$typityp = 'DLAwidmund'">
        <xsl:text> Widmungsexemplar Deutsches Literaturarchiv</xsl:text>
    </xsl:when>
    <xsl:when test="$typityp = 'jugend-in-wien'">
        <xsl:text> Jugend in Wien</xsl:text>
    </xsl:when>
    <xsl:when test="$typityp = 'gnd'">
        <xsl:text> Wikipedia?</xsl:text>
    </xsl:when>
    <xsl:when test="$typityp = 'schnitzler-briefe'">
        <xsl:text> Bahr/Schnitzler</xsl:text>
    </xsl:when>
    <xsl:when test="$typityp = 'widmungDLA'">
        <xsl:text> Widmung DLA</xsl:text>
    </xsl:when>
    <xsl:otherwise>
        <xsl:text></xsl:text>
        <xsl:value-of select="$typityp"/>
    </xsl:otherwise>
</xsl:choose>
</xsl:function>
</xsl:stylesheet>