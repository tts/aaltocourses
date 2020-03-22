<?xml version="1.0"?>

<!-- 

  Tuija Sonkkila, 2020-03-18

  Data harvested with Python from courses.aalto.fi, built to a directed graph, opened in Gephi for 
  graph layout, modularity coloring, and node sizing based on in-degree ranking, and exported as a graph (gexf) file 
  to be visualized with the JavaScript GEFX Viewer.
  
  Here, the outbound link value is copied to the weight attribute of the edge element, and the inbound
  link to the label attribute. Also, default node attribute labels are replaced by their string value.

  gefxjs.js needs to be tweaked to reflect the string data type of weight.

  Run command: java -jar saxon9he.jar graph_from_gephi.gexf transformgraph.xsl > courses_to_show.gexf 

-->

<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:g="http://www.gexf.net/1.3" 
    version="2.0">

 <xsl:output method="xml" indent="yes" />

 <xsl:variable name="inboundlinkid">
    <xsl:value-of select="/g:gexf/g:graph/g:attributes[@class='edge']/g:attribute[@title='inboundtitle']/@id"/>
  </xsl:variable>

  <xsl:variable name="outboundlinkid">
    <xsl:value-of select="/g:gexf/g:graph/g:attributes[@class='edge']/g:attribute[@title='outboundtitle']/@id"/>
  </xsl:variable>

 <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
</xsl:template>

<xsl:template match="g:node/g:attvalues/g:attvalue">
  <xsl:copy>
    <xsl:choose>
      <xsl:when test="@for = '0'">
        <xsl:attribute name="for"><xsl:value-of select="'Title'"/></xsl:attribute>
      </xsl:when>
      <xsl:when test="@for = '1'">
        <xsl:attribute name="for"><xsl:value-of select="'Credits'"/></xsl:attribute>
      </xsl:when>      
      <xsl:when test="@for = '2'">
        <xsl:attribute name="for"><xsl:value-of select="'Language'"/></xsl:attribute>
      </xsl:when>
      <xsl:when test="@for = '3'">
        <xsl:attribute name="for"><xsl:value-of select="'Description'"/></xsl:attribute>
      </xsl:when>
      <xsl:when test="@for = '4'">
        <xsl:attribute name="for"><xsl:value-of select="'School'"/></xsl:attribute>
      </xsl:when>
      <xsl:when test="@for = '5'">
        <xsl:attribute name="for"><xsl:value-of select="'Department'"/></xsl:attribute>
      </xsl:when>
      <xsl:when test="@for = 'modularity_class'">
        <xsl:attribute name="for"><xsl:value-of select="'Modularity class'"/></xsl:attribute>
      </xsl:when>
    </xsl:choose>
    <xsl:apply-templates select="@*[not(name()='for')]"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="g:edge">

   <xsl:variable name="olink">
        <xsl:value-of select="g:attvalues/g:attvalue[@for=$outboundlinkid]/@value"/>
   </xsl:variable>

   <xsl:variable name="ilink">
        <xsl:value-of select="g:attvalues/g:attvalue[@for=$inboundlinkid]/@value"/>
   </xsl:variable>

   <xsl:copy>
     <xsl:attribute name="weight"><xsl:value-of select="$olink"/></xsl:attribute>
     <xsl:attribute name="label"><xsl:value-of select="$ilink"/></xsl:attribute>
     <xsl:apply-templates select="@*"/>
   </xsl:copy>

 </xsl:template>

</xsl:stylesheet>