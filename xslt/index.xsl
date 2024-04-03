<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0" exclude-result-prefixes="tei xsl xs">
    <xsl:output encoding="UTF-8" media-type="text/html" method="xhtml" version="1.0" indent="yes" omit-xml-declaration="yes" />

    <xsl:import href="./partials/html_navbar.xsl" />
    <xsl:import href="./partials/html_head.xsl" />
    <xsl:import href="./partials/html_footer.xsl" />

    <xsl:template match="/">
        <xsl:variable name="doc_title">
            <xsl:value-of select="normalize-space(string-join(.//tei:title[@type='sub']//text()))" />
        </xsl:variable>
        <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html&gt;</xsl:text>
        <html xmlns="http://www.w3.org/1999/xhtml">
            <head>
                <xsl:call-template name="html_head">
                    <xsl:with-param name="html_title" select="$doc_title"></xsl:with-param>
                </xsl:call-template>
            </head>

            <body class="page" style="background-color:#f1f1f1;">
                <div class="hfeed site" id="page">
                    <header>
                        <xsl:call-template name="nav_bar" />
                    </header>
                    <main>
                        <div class="container">
                            <div class="row intro">
                                <div class="col-md-6 col-lg-6 col-sm-12 wp-intro_left">
                                    <div class="intro_left">
                                        <h3 class="mt-3">Paul Tillich</h3>
                                        <h1 class="mt-3" style="text-align: left;">Korrespondenz</h1>
                                        <h3 class="mt-3">1886 - 1933</h3>
                                        <h4 style="font-style: italic">Herausgegeben von Christian Danz und Friedrich Wilhelm Graf. Wien/München 2021-2024</h4>
                                        <h4 style="font-style: italic">Page under construction ...</h4>
                                        <!--
                                     <div style="text-align: right"><a href="#body"><button class="btn btn-round" style="background-color: #A63437; color:
                                        white;">Weiter</button></a></div>
                                     -->
                                    </div>
                                </div>
                                <div class="col-md-6 col-lg-6 col-sm-12">
                                    <div class="intro_right wrapper">
                                        <img src="images/Steffi Brandl_Ohne Titel_1932.jpg" class="d-block w-100" style="max-width=30%;" alt="Bildnachweis: Steffi Brandl, Ohne Titel (Porträt Paul Tillich), 1932, © Berlinische Galerie" title="Bildnachweis: Steffi Brandl, Ohne Titel (Porträt Paul Tillich), 1932, Repro: Anja Elisabeth Witte/Berlinische Galerie." />
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="container-fluid" style="margin:2em auto;" id="body">
                            <div style="max-width: 650px; margin: auto;">
                                <span style="display: block;position: relative; top: -250px; visibility: hidden" id="body"></span>
                                <p class="mt-3">Die digitale Edition der Korrespondenz des Theologen Paul Tillich enthält derzeit über 900 Briefe und umfasst den Zeitraum von seiner Geburt 1886 bis zu seiner Emigration in die USA 1933. Der Briefbestand der Edition wird laufend ergänzt und weiter ediert. Es sind zwei weitere Projektphasen (1933-1951 und 1951-1965) geplant, so dass am Ende des Projekts Paul Tillichs gesamte Korrespondenz als kritische Open Access Edition digital vorliegt.</p>
                                <!-- 
                                <p class="mt-3" style="padding-bottom: 50px;">Die 44. Korrespondenz,
        jene mit Paul Goldmann, ist fast vollständig ediert. Das sind rund 560 Briefe. Von der 45.
        Korrespondenz, dem Austausch mit Felix Salten, liegen fast 380 Briefe vor. Beide
        Korrespondenzen werden fortlaufend erweitert. (<a href="status.html">Projektstand</a>) </p>
                                <a href="L00001.html">
                                    <button class="btn btn-round">Lesen</button>
                                </a>
                                <span>&nbsp;&nbsp;&nbsp;&nbsp;</span>
                                <a href="about.html">
                                    <button class="btn btn-round">Zum Projekt</button>
                                </a>-->
                            </div>
                        </div>
                        <!--         
                         <div class="container-fluid" style="margin:2em auto;">
                            <div class="row wrapper img_bottom">
                               <div class="col-md-6 col-lg-6 col-sm-12"><a href="tocs.html" class="index-link">
                                     <div class="card index-card">
                                        <div class="card-body"><img class="d-block w-100" src="https://shared.acdh.oeaw.ac.at/schnitzler-briefe/img/korrespondenzen.jpg" title="Quelle: ANNO, Die Bühne, datum=19310315" alt="Schnitzlers
                        Arbeitstisch"></div>
                                        <div class="card-header">
                                           <h4>Korrespondenzen </h4>
                                           <p>Auswahl anhand der Korrespondenzpartnerinnen und
                                              -partner.</p>
                                        </div>
                                     </div></a></div>
                               <div class="col-md-6 col-lg-6 col-sm-12"><a href="toc.html" class="index-link">
                                     <div class="card index-card">
                                        <div class="card-body"><img class="d-block w-100" src="https://shared.acdh.oeaw.ac.at/schnitzler-briefe/img/brief.jpg" alt="Briefumschlag mit Schnitzlers aufgedruckter Absenderadresse"></div>
                                        <div class="card-header">
                                           <h4>Korrespondenzstücke</h4>
                                           <p>Verzeichnis aller edierten Briefe, Karten,
                                              Widmungsexemplare und Telegramme.</p>
                                        </div>
                                     </div></a></div>
                               <div class="col-md-6 col-lg-6 col-sm-12"><a href="calendar.html" class="index-link">
                                     <div class="card index-card">
                                        <div class="card-body"><img class="d-block w-100" src="https://shared.acdh.oeaw.ac.at/schnitzler-briefe/img/calendar.jpg" title="Detail aus http://www.ifm-wolfen.de/index.php?id=110005000534 CC
                        BY-NC-SA" alt="Kalenderdetail"></div>
                                        <div class="card-header">
                                           <h4>Kalender</h4>
                                           <p>Korrespondenzstücke anhand eines Datums finden.</p>
                                        </div>
                                     </div></a></div>
                               <div class="col-md-6 col-lg-6 col-sm-12"><a href="listperson.html" class="index-link">
                                     <div class="card index-card">
                                        <div class="card-body"><img class="d-block w-100" src="https://shared.acdh.oeaw.ac.at/schnitzler-briefe/img/persons.jpg" title="Zwei der Kinder von Felix Salten, aus einem Brief von Salten an
                        Schnitzler, Cambridge University Library" alt="Zwei der Kinder von Felix
                        Salten, aus einem Brief von diesem an Schnitzler, Cambridge University
                        Library"></div>
                                        <div class="card-header">
                                           <h4>Personen</h4>
                                           <p>In den Korrespondenzstücken erwähnte Personen.</p>
                                        </div>
                                     </div></a></div>
                               <div class="col-md-6 col-lg-6 col-sm-12"><a href="listwork.html" class="index-link">
                                     <div class="card index-card">
                                        <div class="card-body"><img class="d-block w-100" src="https://shared.acdh.oeaw.ac.at/schnitzler-briefe/img/werke.jpg" title="Nahaufnahme von Buchrücken CC BY 0" alt="Nahaufnahme von
                        Buchrücken"></div>
                                        <div class="card-header">
                                           <h4>Werkverzeichnis</h4>
                                           <p>In den Korrespondenzstücken erwähnte literarische wie
                                              nicht-literarische Werke.</p>
                                        </div>
                                     </div></a></div>
                               <div class="col-md-6 col-lg-6 col-sm-12"><a href="listplace.html" class="index-link">
                                     <div class="card index-card">
                                        <div class="card-body"><img class="d-block w-100" src="https://shared.acdh.oeaw.ac.at/schnitzler-briefe/img/places.jpg" alt="Stadtplan von Wien innerhalb des Gürtels, Beilage zum Meyers
                        Konversationslexikon von 1905." title="Stadtplan von Wien innerhalb des
                        Gürtels, Beilage zum Meyers Konversationslexikon von 1905."></div>
                                        <div class="card-header">
                                           <h4>Orte</h4>
                                           <p>In den Korrespondenzstücken erwähnte geografische
                                              Orte. Diese sind auch über ihre Koordinaten
                                              erschlossen.</p>
                                        </div>
                                     </div></a></div>
                               <div class="col-md-6 col-lg-6 col-sm-12"><a href="listorg.html" class="index-link">
                                     <div class="card index-card">
                                        <div class="card-body"><img class="d-block w-100" src="https://shared.acdh.oeaw.ac.at/schnitzler-briefe/img/org.jpg" title="Briefkopf d’Ora" alt="Briefkopf d’Ora"></div>
                                        <div class="card-header">
                                           <h4>Institutionen und Organisationen</h4>
                                           <p>In den Korrespondenzstücken erwähnte Verlage,
                                              Redaktionen, Vereine, Gesellschaften, Firmen, Preise
                                              …</p>
                                        </div>
                                     </div></a></div>
                               <div class="col-md-6 col-lg-6 col-sm-12"><a href="https://schnitzler.acdh.oeaw.ac.at/" class="index-link" target="_blank">
                                     <div class="card index-card">
                                        <div class="card-body"><img class="d-block w-100" src="https://shared.acdh.oeaw.ac.at/schnitzler-briefe/img/schnitzler-acdh.jpg" title="Schnitzler am ACDH-CH" alt="Schnitzler am ACDH-CH"></div>
                                        <div class="card-header">
                                           <p>Schnitzler am ACDH-CH</p>
                                        </div>
                                     </div></a></div>
                               <div class="col-md-6 col-lg-6 col-sm-12"><a href="https://github.com/arthur-schnitzler" class="index-link">
                                     <div class="card index-card">
                                        <div class="card-body"><img class="d-block w-100" src="https://shared.acdh.oeaw.ac.at/schnitzler-briefe/img/schnitzler-github.jpg" title="Schnitzler Repositories auf Github" alt="Schnitzler Repositories auf
                        Github"></div>
                                        <div class="card-header">
                                           <p>Quelldaten dieser Webseite auf GitHub</p>
                                        </div>
                                     </div></a></div>
                            </div>
                         </div>
                         -->
                    </main>

                    <footer>
                        <xsl:call-template name="html_footer" />
                    </footer>
                    <script src="https://cdn.jsdelivr.net/npm/typesense-instantsearch-adapter@2/dist/typesense-instantsearch-adapter.min.js"></script>
                    <script src="https://cdn.jsdelivr.net/npm/algoliasearch@4.5.1/dist/algoliasearch-lite.umd.js" integrity="sha256-EXPXz4W6pQgfYY3yTpnDa3OH8/EPn16ciVsPQ/ypsjk=" crossorigin="anonymous"></script>
                    <script src="https://cdn.jsdelivr.net/npm/instantsearch.js@4.8.3/dist/instantsearch.production.min.js" integrity="sha256-LAGhRRdtVoD6RLo2qDQsU2mp+XVSciKRC8XPOBWmofM=" crossorigin="anonymous"></script>
                    <script src="js/listStopProp.js"></script>
                    <script src="https://code.jquery.com/jquery-3.6.3.min.js" integrity="sha256-pvPw+upLPUjgMXY0G+8O0xUf+/Im1MZjXxxgOcBQBXU=" crossorigin="anonymous"></script>
                </div>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>