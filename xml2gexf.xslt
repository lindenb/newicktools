<?xml version='1.0'  encoding="UTF-8" ?>
<xsl:stylesheet
        xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
	xmlns='http://www.gexf.net/1.2draft'
	xmlns:viz="http://www.gexf.net/1.1draft/viz"
        version='1.0'
        >
<!--
Author:
        Pierre Lindenbaum
        http://plindenbaum.blogspot.com
Motivation:
      transforms Newick/xml to  gexf ( see www.gephi.org )
f
-->

<xsl:output method="xml" indent="yes"/>

<xsl:template match="/">
<gexf xmlns="http://www.gexf.net/1.2draft" version="1.2">
    <meta>
        <creator>Pierre Lindenbaum</creator>
        <description>Newick Taxonmy</description>
    </meta>
    <attributes class="node">
            <attribute id="0" title="label" type="string"/>
            <attribute id="1" title="length" type="string"/>
    </attributes>
    <graph mode="static" defaultedgetype="directed">
    <nodes>
      <xsl:apply-templates select="//node" mode="node"/>
    </nodes>
    <edges>
      <xsl:apply-templates select="*" mode="edge"/>
    </edges>
    </graph>
</gexf>
</xsl:template>

<xsl:template match="node" mode="node">
  <xsl:element name="node">
    <xsl:attribute name="id">
      <xsl:value-of select="@id"/>
    </xsl:attribute>

    <xsl:attribute name="label">
    	<xsl:choose>
    		<xsl:when test="@label"><xsl:value-of select="@label"/></xsl:when>
    		<xsl:otherwise> <xsl:value-of select="@id"/></xsl:otherwise>
    	</xsl:choose>
    </xsl:attribute>

    <attvalues>
            <attvalue for="0">
		    <xsl:attribute name="value">
		      <xsl:value-of select="@label"/>
		    </xsl:attribute>
            </attvalue>
             <attvalue for="1">
		    <xsl:attribute name="value">
		      <xsl:value-of select="@length"/>
		    </xsl:attribute>
            </attvalue>
     </attvalues>
  </xsl:element>
</xsl:template>

<xsl:template match="node" mode="edge">

<xsl:if test="count(children/node)&gt;0">
<xsl:variable name="rootid">
      <xsl:value-of select="@id"/>
</xsl:variable>
<xsl:for-each select="children/node">

<edge>
	<xsl:if test="@length">
	    <xsl:attribute name="label">
	    	 <xsl:value-of select="@length"/>
	    </xsl:attribute>
	</xsl:if>
    <xsl:attribute name="id">
      <xsl:value-of select="generate-id(.)"/>
    </xsl:attribute>
    <xsl:attribute name="source">
      <xsl:value-of select="$rootid"/>
    </xsl:attribute>
    <xsl:attribute name="target">
      <xsl:value-of select="@id"/>
    </xsl:attribute>
</edge>
 <xsl:apply-templates select="." mode="edge"/>
</xsl:for-each>
</xsl:if>

</xsl:template>


</xsl:stylesheet>
