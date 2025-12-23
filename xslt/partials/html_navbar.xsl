<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all" version="2.0">
    <xsl:template match="/" name="nav_bar">
        <header>
            <nav aria-label="Primary" class="navbar navbar-expand-lg">
                <div class="container-fluid">
                    <a class="navbar-brand" href="index.html">
                        <img src="images/logo.png" alt="Logo der Tillich-Korrespondenz" height="90"/>
                    </a>
                    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
                        <span class="navbar-toggler-icon"></span>
                    </button>
                    <nav aria-label="Haupt Navigation" class="collapse navbar-collapse" id="navbarSupportedContent">
                        <ul class="navbar-nav ms-auto me-2 mb-lg-0">
                            <li class="nav-item dropdown">
                                <a class="nav-link dropdown-toggle" href="#" role="button" id="projektDropdown" data-bs-toggle="dropdown" aria-expanded="false" aria-haspopup="true">Projekt</a>
                                <ul class="dropdown-menu" aria-labelledby="projektDropdown">
                                    <li>
                                        <a class="dropdown-item" href="editionsrichtlinien.html">Editionsrichtlinien</a>
                                    </li>
                                    <li><hr class="dropdown-divider"/></li>
                                    <li>
                                        <a class="dropdown-item" href="imprint.html">Impressum</a>
                                    </li>
                                </ul>
                            </li>

                            <li class="nav-item dropdown">
                                <a class="nav-link dropdown-toggle" href="#" role="button" id="briefeDropdown" data-bs-toggle="dropdown" aria-expanded="false" aria-haspopup="true">Briefe</a>
                                <ul class="dropdown-menu" aria-labelledby="briefeDropdown">
                                    <li>
                                        <a class="dropdown-item" href="toc.html">Alle Briefe</a>
                                    </li>
                                    <li>
                                        <a class="dropdown-item" href="corresp_toc.html">Alle Korrespondenzen</a>
                                    </li>
                                    <li>
                                        <a class="dropdown-item" href="calendar.html">Briefkalender</a>
                                    </li>
                                </ul>
                            </li>

                            <li class="nav-item dropdown">
                                <a class="nav-link dropdown-toggle" href="#" role="button" id="registerDropdown" data-bs-toggle="dropdown" aria-expanded="false" aria-haspopup="true">Register</a>
                                <ul class="dropdown-menu" aria-labelledby="registerDropdown">
                                    <li>
                                        <a class="dropdown-item" href="listperson.html">Personen</a>
                                    </li>
                                    <li>
                                        <a class="dropdown-item" href="listplace.html">Orte</a>
                                    </li>
                                    <li>
                                        <a class="dropdown-item" href="listbibl.html">Werke</a>
                                    </li>
                                    <li>
                                        <a class="dropdown-item" href="listbible.html">Bibelstellen</a>
                                    </li>
                                </ul>
                            </li>

                            <li class="nav-item d-lg-none">
                                <a class="nav-link" href="search.html">Suche</a>
                            </li>
                        </ul>
                        <div class="d-none d-lg-block">
                            <form class="d-flex" role="search" action="search.html" method="get">
                                <label for="search-input" class="visually-hidden">Suche</label>
                                <input
                                    class="form-control me-2"
                                    type="text"
                                    id="search-input"
                                    name="tillich-briefe[query]"
                                    placeholder="Suche"
                                    aria-label="Search"
                                />
                                <button class="btn btn-primary" type="submit">Suchen</button>
                            </form>
                        </div>
                    </nav>
                </div>
            </nav>
        </header>
    </xsl:template>
</xsl:stylesheet>