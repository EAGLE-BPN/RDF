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

    <xsl:template match="t:TEI">
        <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
            xmlns:lawd="http://lawd.info/ontology/" 
            xmlns:oa="http://www.w3.org/ns/oa#"
            xmlns:crm="http://www.cidoc-crm.org/cidoc-crm/"
            xmlns:gn="http://www.geonames.org/ontology#" 
            xmlns:dcterms="http://purl.org/dc/terms/"
            xmlns:bm="http://betamasaheft.eu/docs.html#"
            xmlns:pelagios="http://pelagios.github.io/vocab/terms#"
            xmlns:dc="http://purl.org/dc/elements/1.1/"
            xmlns:skos="http://www.w3.org/2004/02/skos/core#"
            xmlns:pleiades="https://pleiades.stoa.org/" 
            xmlns:wd="https://www.wikidata.org/"
            xmlns:foaf="http://xmlns.com/foaf/0.1/"
            xmlns:eagle="https://www.eagle-network.eu/"
            xmlns:geo="http://www.w3.org/2003/01/geo/wgs84_pos#">
            <xsl:variable name="mainuri">
                <xsl:value-of select="//t:idno[@type = 'URI']"/>
            </xsl:variable>
            <xsl:variable name="mainID">
                <xsl:value-of select="//t:idno[@type = 'localID']"/>
            </xsl:variable>
            <crm:E71_Man_Made_Thing rdf:about="{$mainuri}">
                <dcterms:temporal rdf:resource="http://n2t.net/ark:/99152/p03wskd389m"/>
                <dcterms:subject>inscription</dcterms:subject>
                <crm:P48_has_preferred_identifier>
                    <xsl:value-of select="$mainID"/>
                </crm:P48_has_preferred_identifier>
                <xsl:if test="//t:idno[@type='TM']">
                    <crm:P1_is_identified_by><xsl:attribute name="rdf:resource"><xsl:value-of select="concat('http://www.trismegistos.org/text/',//t:idno[@type='TM'])"/></xsl:attribute></crm:P1_is_identified_by>
                </xsl:if>
                <xsl:if test="//t:idno[not(@type='TM')][not(@type='URI')][not(@type='localID')]">
                    <xsl:for-each select="//t:idno[not(@type='TM')][not(@type='URI')][not(@type='localID')]">
                        <crm:P1_is_identified_by><xsl:value-of select="."/></crm:P1_is_identified_by>
                    </xsl:for-each>
                </xsl:if>
                <rdf:type rdf:resource="http://pelagios.github.io/vocab/terms#AnnotatedThing"/>
                <rdf:type>
                    <crm:E34_Inscription>
                        <xsl:apply-templates select="//t:term[@ref]"/>
                        <xsl:apply-templates select="//t:rs[@type = 'execution'][@ref]"/>
                    </crm:E34_Inscription>
                </rdf:type>
                <rdf:type>
                    <crm:E84_Information_Carrier>
                        <xsl:apply-templates select="//t:objectType[@ref]"/>
                        <xsl:apply-templates select="//t:material[@ref]"/>
                        <xsl:apply-templates select="//t:rs[@type = 'statePreserv'][@ref]"/>
                        <xsl:apply-templates select="//t:rs[@type = 'decoration'][@ref]"/>
                        <xsl:apply-templates select="//t:dimensions"/>
                    </crm:E84_Information_Carrier>
                </rdf:type>
                <foaf:primaryTopicOf rdf:resource="{$mainuri}"/>
                <xsl:apply-templates select="//t:title"/>
                <xsl:apply-templates select="//t:language"/>
                <xsl:apply-templates select="//t:origDate"/>
            </crm:E71_Man_Made_Thing>

            <xsl:for-each select="//t:placeName[@ref[matches(.,'pleiades') or matches(.,'trismegistos')]]">
                <xsl:sort/>
                <xsl:call-template name="places">
                    <xsl:with-param name="mainuri">
                        <xsl:value-of select="$mainuri"/>
                    </xsl:with-param>
                    <xsl:with-param name="n">
                        <xsl:value-of select="position()"/>
                    </xsl:with-param>

                </xsl:call-template>
            </xsl:for-each>

        </rdf:RDF>
    </xsl:template>

    <xsl:template match="t:dimensions">
        <crm:P43_has_dimension>
            <crm:E54_Dimension>
                <xsl:for-each select="child::node()">
                    <crm:P40_observed_dimension>
                        <xsl:value-of select="."/>
                    </crm:P40_observed_dimension>
                </xsl:for-each>
            </crm:E54_Dimension>
        </crm:P43_has_dimension>
    </xsl:template>

    <xsl:template match="t:material">
        <crm:P46_is_composed_of>
            <xsl:attribute name="rdf:resource">
                <xsl:value-of select="@ref"/>
            </xsl:attribute>
        </crm:P46_is_composed_of>
    </xsl:template>

    <xsl:template match="t:rs[@type = 'statePreserv']">
        <crm:P44_has_condition>
            <xsl:attribute name="rdf:resource">
                <xsl:value-of select="@ref"/>
            </xsl:attribute>
        </crm:P44_has_condition>
    </xsl:template>
    
    <xsl:template match="t:rs[@type = 'execution']">
        <rdf:type>
            <xsl:attribute name="rdf:resource">
                <xsl:value-of select="@ref"/>
            </xsl:attribute>
        </rdf:type>
    </xsl:template>
    <xsl:template match="t:rs[@type = 'decoration']">
        <rdf:type>
            <xsl:attribute name="rdf:resource">
                <xsl:value-of select="@ref"/>
            </xsl:attribute>
        </rdf:type>
    </xsl:template>
    <xsl:template match="t:objectType">
        <crm:P2_has_type>
            <xsl:attribute name="rdf:resource">
                <xsl:value-of select="@ref"/>
            </xsl:attribute>
        </crm:P2_has_type>
    </xsl:template>
    <xsl:template match="t:term">
        <crm:P2_has_type>
            <xsl:attribute name="rdf:resource">
                <xsl:value-of select="@ref"/>
            </xsl:attribute>
        </crm:P2_has_type>
    </xsl:template>

    <xsl:template match="t:language">
        <dc:language rdf:datatype="http://www.w3.org/2001/XMLSchema#language">
            <xsl:value-of select="@ident"/>
        </dc:language>
    </xsl:template>

    <xsl:template match="t:origDate">
        <dcterms:temporal> <xsl:choose>
            <xsl:when test="@when"><xsl:value-of select="@when"/></xsl:when>
            <xsl:when test="@notBefore and @notAfter">
                <xsl:value-of select="concat(@notBefore, '/', @notAfter)"/>
            </xsl:when>
            <xsl:when test="@notBefore-custom and @notAfter-custom">
                <xsl:value-of select="concat(@notBefore-custom, '/', @notAfter-custom)"/>
            </xsl:when>
        </xsl:choose></dcterms:temporal>
        <crm:P4_has_time_span>
            <xsl:choose>
                <xsl:when test="@when">
                    <crm:E52_Time-span>
                        <crm:P79_beginning_is_qualified_by
                            rdf:datatype="http://www.w3.org/2001/XMLSchema#date">
                            <xsl:value-of select="@when"/>
                        </crm:P79_beginning_is_qualified_by>
                        <crm:P79_end_is_qualified_by
                            rdf:datatype="http://www.w3.org/2001/XMLSchema#date">
                            <xsl:value-of select="@when"/>
                        </crm:P79_end_is_qualified_by>
                    </crm:E52_Time-span>
                </xsl:when>
                <xsl:when test="@notBefore or @notAfter">
                    <crm:E52_Time-span>
                        <xsl:if test="@notBefore">
                            <crm:P79_beginning_is_qualified_by
                                rdf:datatype="http://www.w3.org/2001/XMLSchema#date">
                                <xsl:value-of select="@notBefore"/>
                            </crm:P79_beginning_is_qualified_by>
                        </xsl:if>
                        <xsl:if test="@notAfter">
                            <crm:P80_end_is_qualified_by
                                rdf:datatype="http://www.w3.org/2001/XMLSchema#date">
                                <xsl:value-of select="@notAfter"/>
                            </crm:P80_end_is_qualified_by>
                        </xsl:if>
                    </crm:E52_Time-span>
                </xsl:when>
                <xsl:when test="@notBefore-custom or @notAfter-custom">
                    <crm:E52_Time-span>
                        <xsl:if test="@notBefore-custom">
                            <crm:P79_beginning_is_qualified_by
                                rdf:datatype="http://www.w3.org/2001/XMLSchema#date">
                                <xsl:value-of select="format-date(xs:date(@notBefore-custom), '[Y0]')"/>
                            </crm:P79_beginning_is_qualified_by>
                        </xsl:if>
                        <xsl:if test="@notAfter-custom">
                            <crm:P80_end_is_qualified_by
                                rdf:datatype="http://www.w3.org/2001/XMLSchema#date">
                                <xsl:value-of select="format-date(xs:date(@notAfter-custom), '[Y0]')"/>
                            </crm:P80_end_is_qualified_by>
                        </xsl:if>
                    </crm:E52_Time-span>
                </xsl:when>
                <xsl:otherwise>
                    <crm:E52_Time-span>
                        <crm:P78_is_identified_by>
                            <xsl:value-of select="."/>
                        </crm:P78_is_identified_by>
                    </crm:E52_Time-span>
                </xsl:otherwise>
            </xsl:choose>

        </crm:P4_has_time_span>
    </xsl:template>


    <xsl:template match="t:title">
        <dc:title>
            <xsl:value-of select="."/>
        </dc:title>
    </xsl:template>


    <xsl:template name="places">
        <xsl:param name="mainuri"/>
        <xsl:param name="n"/>
        <oa:Annotation rdf:about="{$mainuri}/annotations/{$n}">
            <oa:hasTarget rdf:resource="{$mainuri}"/>
            <oa:hasBody
                rdf:resource="{if(starts-with(@ref, 'pleiades:')) then concat('https://pleiades.stoa.org/places/', substring-after(@ref, 'pleiades:')) else if (starts-with(@ref, 'Q')) then concat('https://www.wikidata.org/entity/', @ref) else @ref}"/>
            <oa:annotatedAt rdf:datatype="http://www.w3.org/2001/XMLSchema#date">
                <xsl:value-of select="current-date()"/>
            </oa:annotatedAt>
        </oa:Annotation>
    </xsl:template>



</xsl:stylesheet>
