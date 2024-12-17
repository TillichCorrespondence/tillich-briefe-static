<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <xsl:template match="/" name="tabulator_dl_buttons">
        <div class="d-flex justify-content-end pt-5 pb-2">
            <div class="text-end">
                <h2>Download Optionen</h2>
                <div class="button-group pt-3">
                    <button type="button" class="btn btn-outline-primary" id="download-csv"
                        title="Download CSV">
                        <i class="bi bi-filetype-csv"/>
                        <span class="ps-2">Download CSV</span>
                    </button>
                    <button type="button" class="btn btn-outline-primary" id="download-json"
                        title="Download JSON">
                        <i class="bi bi-filetype-json"/>
                        <span class="ps-2">Download JSON</span>
                    </button>
                    <button type="button" class="btn btn-outline-primary" id="download-html"
                        title="Download HTML">
                        <i class="bi bi-filetype-html"/>
                        <span class="ps-2">Download HTML</span>
                    </button>
                </div>
            </div>
        </div>
    </xsl:template>
</xsl:stylesheet>
