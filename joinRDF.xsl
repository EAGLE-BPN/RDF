<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:crm="http://www.cidoc-crm.org/cidoc-crm/"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" 
    xmlns:lawd="http://lawd.info/ontology/"
    xmlns:oa="http://www.w3.org/ns/oa#" 
    xmlns:gn="http://www.geonames.org/ontology#"
    xmlns:dcterms="http://purl.org/dc/terms/"
    xmlns:pelagios="http://pelagios.github.io/vocab/terms#"
    xmlns:dc="http://purl.org/dc/elements/1.1/" 
    xmlns:skos="http://www.w3.org/2004/02/skos/core#"
    xmlns:pleiades="https://pleiades.stoa.org/" 
    xmlns:foaf="http://xmlns.com/foaf/0.1/"
    xmlns:wd="https://www.wikidata.org/" 
    xmlns:geo="http://www.w3.org/2003/01/geo/wgs84_pos#"
    xmlns:eagle="https://www.eagle-network.eu/"
    xmlns:t="http://www.tei-c.org/ns/1.0" version="2.0">
    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
    
    <xsl:template match="//set">
        <xsl:result-document href="{shortname}.rdf">
        <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
            xmlns:lawd="http://lawd.info/ontology/" 
            xmlns:oa="http://www.w3.org/ns/oa#"
            xmlns:gn="http://www.geonames.org/ontology#"
            xmlns:dcterms="http://purl.org/dc/terms/" 
            xmlns:bm="http://betamasaheft.eu/docs.html#"
            xmlns:pelagios="http://pelagios.github.io/vocab/terms#"
            xmlns:dc="http://purl.org/dc/elements/1.1/"
            xmlns:skos="http://www.w3.org/2004/02/skos/core#"
            xmlns:pleiades="https://pleiades.stoa.org/" 
            xmlns:foaf="http://xmlns.com/foaf/0.1/"
            xmlns:wd="https://www.wikidata.org/" 
            xmlns:geo="http://www.w3.org/2003/01/geo/wgs84_pos#"
            xmlns:eagle="https://www.eagle-network.eu/"
            xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#">
            <xsl:variable name="buri" select="baseuri/text()"/>
            <xsl:for-each select="collection('../RDF')//crm:E71_Man_Made_Thing[starts-with(@rdf:about, $buri)]">
                <xsl:copy exclude-result-prefixes="#all"><xsl:copy-of exclude-result-prefixes="#all" select="@* | node()"></xsl:copy-of></xsl:copy>
            </xsl:for-each>
            <xsl:for-each select="collection('../RDF')//oa:Annotation[starts-with(@rdf:about, $buri)]">
                <xsl:copy exclude-result-prefixes="#all"><xsl:copy-of exclude-result-prefixes="#all" select="@* | node()"></xsl:copy-of></xsl:copy>
            </xsl:for-each>
        </rdf:RDF>  
        </xsl:result-document>
        <xsl:result-document href="{shortname}.void.rdf">
            <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:void="http://rdfs.org/ns/void#"
                xmlns:dc="http://purl.org/dc/terms/"
                xmlns:foaf="http://xmlns.com/foaf/0.1/">
                
                <void:Dataset rdf:about="{baseuri}">
                    <dc:title><xsl:value-of select="title"/></dc:title>
                    <dc:publisher>International Digital Epigraphy Association</dc:publisher>
                    <foaf:homepage rdf:resource="{baseuri}"/>
                    <dc:description>A dataset of annotated inscriptions.</dc:description>
                    <dc:license rdf:resource="http://opendatacommons.org/licenses/by/"/>
                    <void:dataDump rdf:resource="https://raw.githubusercontent.com/EAGLE-BPN/RDF/master/{shortname}.rdf"/>
                </void:Dataset>
                
            </rdf:RDF>
        </xsl:result-document>
    </xsl:template>

    
    
</xsl:stylesheet>