<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xsl tei xs" version="2.0">
    <xsl:template match="/" name="nav_bar">

        <nav class="navbar navbar-expand-md" style="padding-top:1px;">
            <div class="container-fluid">
                <a href="index.html" class="navbar-brand custom-logo-link" rel="home" itemprop="url">
                    <img src="images/logo.png" class="img-fluid" title="Tillich Briefe" alt="Tillich Briefe" itemprop="logo"/>
                </a>
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation" style="border: none;">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse " id="navbarNav">
                    <ul class="navbar-nav ms-auto">
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">Projekt</a>
                            <ul class="dropdown-menu">
                                <li class="nav-item dropdown-submenu">
                                    <a class="nav-link" href="editionsrichtlinien.html">Editionsrichtlinien</a>
                                </li>
                                <li><hr class="dropdown-divider" /></li>
                                <li class="nav-item dropdown-submenu">
                                    <a class="nav-link" href="https://github.com/TillichCorrespondence/tillich-briefe-static">Quellcode der Website</a>
                                </li>
                                <li class="nav-item dropdown-submenu">
                                    <a class="nav-link" href="https://github.com/TillichCorrespondence/tillich-briefe-data">Daten-Repo</a>
                                </li>
                            </ul>
                        </li>                        
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">Briefe</a>
                            <ul class="dropdown-menu">
                                <li class="nav-item dorpdown-submenu">
                                    <a class="nav-link" href="toc.html">Alle Briefe</a>
                                </li>
                                <li class="nav-item dorpdown-submenu">
                                    <a class="nav-link" href="corresp_toc.html">Alle Korrespondenzen</a>
                                </li>
                            </ul>
                            
                        </li>
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">Index</a>

                            <ul class="dropdown-menu">
                                <li class="nav-item dropdown-submenu">
                                    <a class="nav-link" href="listperson.html">Personen</a>
                                </li>
                                <li class="nav-item dropdown-submenu">
                                    <a class="nav-link" href="listwork.html">Werke</a>
                                </li>
                                <li class="nav-item dropdown-submenu">
                                    <a class="nav-link" href="listplace.html">Orte</a>
                                </li>
                                <li class="nav-item dropdown-submenu">
                                    <a class="nav-link" href="listbibl.html">Bibliograhie</a>
                                </li>
                            </ul>

                        </li>
                        <li class="nav-item">
                            <a title="Suche" class="nav-link" href="search.html">
                                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-search">
                                    <circle cx="11" cy="11" r="8"></circle>
                                    <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                                </svg>SUCHE</a>
                        </li>
                    </ul>
                </div>
            </div>
        </nav>

    </xsl:template>
</xsl:stylesheet>