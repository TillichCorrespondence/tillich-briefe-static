<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
    version="2.0" exclude-result-prefixes="xsl tei xs">
    <xsl:import href="./person.xsl"/>
    <xsl:import href="./place.xsl"/>
    
       <!-- handle <rs> entities -->
    <xsl:key name="persons-by-id" match="tei:person" use="@xml:id"/>

   <xsl:template match="tei:rs[starts-with(@ref, '#') and @type]">
    <xsl:variable name="entType" select="@type"/>
    <xsl:variable name="entRefs" select="tokenize(normalize-space(@ref), '\s+')"/>
    
    <xsl:choose>
        <!-- Multiple person refs - just create the link -->
        <xsl:when test="@type='person' and count($entRefs) &gt; 1">
            <xsl:variable name="modalId" select="concat('modal-', generate-id())"/>
            <a href="#" role="button" class="{$entType} entity multiple-refs"
               aria-haspopup="dialog"
               data-bs-toggle="modal"
               data-bs-target="#{$modalId}"
               data-modal-id="{$modalId}"
               data-person-refs="{@ref}">
                <xsl:apply-templates/>
                <span class="visually-hidden"> (Details anzeigen)</span>
            </a>
        </xsl:when>
        
        <!-- Single ref - original behavior -->
        <xsl:otherwise>
            <xsl:variable name="entId" select="$entRefs[1]"/>
            <a href="#" role="button" class="{$entType} entity" 
               aria-haspopup="dialog"
               data-bs-toggle="modal"
               data-bs-target="{$entId}">
                <xsl:apply-templates/>
                <span class="visually-hidden"> (Details anzeigen)</span>
            </a>
            
            <!-- anchor for PDF -->
            <a class="pdf-entitiy-footnote-markers visually-hidden" aria-hidden="true">
                <xsl:attribute name="name">
                    <xsl:value-of select="replace($entId, '#', '')"/>
                    <xsl:number level="any" format="a" count="tei:rs[starts-with(@ref, '#') and @type]"/>
                    <xsl:text>anchor</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="href">
                    <xsl:value-of select="$entId"/>
                    <xsl:number level="any" format="a" count="tei:rs[starts-with(@ref, '#') and @type]"/>
                    <xsl:text>endnote</xsl:text>
                </xsl:attribute>
                <sup>
                    <xsl:number level="any" format="a" count="tei:rs[starts-with(@ref, '#') and @type]"/>
                </sup>
            </a>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>


    
    <xsl:template match="tei:rs[@ref and @type='bible']">
        <xsl:variable name="biblId">
            <xsl:value-of select="lower-case(replace(replace(./@ref, ',', '-'), ' ', ''))"/>
        </xsl:variable>
        <xsl:variable name="entType" select="@type"/>
        <span class="{$entType} entity" data-bs-target="{'#'||$biblId}">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    <xsl:template match="tei:listPerson">
        <xsl:apply-templates/>
        <!-- Generate modals for multi-person references -->
    <xsl:apply-templates select="//tei:rs[@type='person' and contains(@ref, ' ')]" mode="generate-modals"/>

    </xsl:template>
    <xsl:template match="tei:listPlace">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="tei:listOrg">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="tei:list[@xml='mentioned']">
        <xsl:apply-templates select=".//tei:item"/>
    </xsl:template>
    
    <xsl:template match="tei:item[@xml:id]">
        <xsl:variable name="selfLink">
            <xsl:value-of select="concat(data(@xml:id), '.html')"/>
        </xsl:variable>
        <xsl:variable name="label">
            <xsl:value-of select="./text()"/>
        </xsl:variable>
        <div class="modal modal fade" id="{@xml:id}" data-bs-keyboard="true" tabindex="-1" aria-labelledby="{$label}" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header">
                        <h1 class="modal-title fs-5" id="staticBackdropLabel"><xsl:value-of select="$label"/></h1>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <a href="{$selfLink}"><xsl:value-of select="$label"/></a> 
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Schließen</button>
                    </div>
                </div>
            </div>
        </div>
    </xsl:template>
    
    <xsl:template match="tei:biblStruct[@xml:id]">
        <xsl:variable name="selfLink">
            <xsl:value-of select="concat(data(@xml:id), '.html')"/>
        </xsl:variable>
        <xsl:variable name="label">
            <xsl:value-of select="@n"/>
        </xsl:variable>
        <div class="modal modal fade" id="{@xml:id}" data-bs-keyboard="true" tabindex="-1" aria-labelledby="{$label}" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header visually-hidden">
                        <h1 class="modal-title fs-5" id="staticBackdropLabel"><xsl:value-of select="$label"/></h1>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <dl>
                            <dt>Kurzzitat</dt>
                            <dd><a href="{$selfLink}"><xsl:value-of select="$label"/></a></dd>
                            
                            <dt>Volle Bibliographische Angabe</dt>
                            <dd><a>
                                    <xsl:attribute name="href">
                                        <xsl:value-of select="@corresp"/>
                                    </xsl:attribute>
                                    Zotero
                            </a>
                            </dd>
                        </dl>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Schließen</button>
                    </div>
                </div>
            </div>
        </div>
    </xsl:template>

    
    <xsl:template match="tei:person">
        <xsl:variable name="selfLink">
            <xsl:value-of select="concat(data(@xml:id), '.html')"/>
        </xsl:variable>
        <xsl:variable name="label">
            <xsl:value-of select="./tei:persName[1]/text()"/>
        </xsl:variable>
        <div class="modal modal fade" id="{@xml:id}" data-bs-keyboard="true" tabindex="-1" aria-label="{$label}" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header">
                        <h1 class="modal-title fs-5" id="staticBackdropLabel">
                            <a href="{$selfLink}"><xsl:value-of select="$label"/></a>
                        </h1>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <xsl:call-template name="person_detail"/> 
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Schließen</button>
                    </div>
                </div>
            </div>
        </div>
    </xsl:template>

    <!-- Generate modals for multi-person references -->
    <xsl:template match="tei:rs[@type='person' and contains(@ref, ' ')]" mode="generate-modals">
        <xsl:variable name="modalId" select="concat('modal-', generate-id())"/>
        <xsl:variable name="entRefs" select="tokenize(normalize-space(@ref), '\s+')"/>
        <xsl:variable name="root" select="root()"/>
        
        <div class="modal fade" id="{$modalId}" data-bs-keyboard="true"
            tabindex="-1"
            aria-label="{normalize-space(.)}" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header">
                        <h1 class="modal-title fs-5">
                            <xsl:value-of select="normalize-space(.)"/>
                        </h1>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"
                                aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <ul>
                            <xsl:for-each select="$entRefs">
                                <xsl:variable name="id" select="substring-after(., '#')"/>
                                <xsl:variable name="person" select="key('persons-by-id', $id, $root)"/>
                                <li>
                                    <xsl:choose>
                                        <xsl:when test="$person">
                                            <a href="{concat($id, '.html')}">
                                                <xsl:value-of select="$person/tei:persName[1]/text()"/>
                                            </a>
                                            <div class="person-detail">
                                                <xsl:for-each select="$person">
                                                    <xsl:call-template name="person_detail"/>
                                                </xsl:for-each>
                                            </div>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="$id"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </li>
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
    
    <xsl:template match="tei:place">
        <xsl:variable name="selfLink">
            <xsl:value-of select="concat(data(@xml:id), '.html')"/>
        </xsl:variable>
        <xsl:variable name="label">
            <xsl:value-of select="./tei:placeName[1]"/>
        </xsl:variable>
        <div class="modal modal fade" id="{@xml:id}" data-bs-keyboard="true" tabindex="-1" aria-label="{$label}" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header">
                        <h1 class="modal-title fs-5" id="staticBackdropLabel">
                            <a href="{$selfLink}"><xsl:value-of select="$label"/></a>
                        </h1>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <xsl:call-template name="place_detail"/> 
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Schließen</button>
                    </div>
                </div>
            </div>
        </div>
    </xsl:template>
    
    
        
</xsl:stylesheet>