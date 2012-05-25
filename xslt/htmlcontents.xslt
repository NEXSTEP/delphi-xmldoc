<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<!-- -->
	<xsl:output method="html" indent="yes"  encoding="utf-8" omit-xml-declaration="yes"/>
	<!-- -->
	<xsl:template match="/">
		<html>
			<head>
				<meta name="generator" content="NEXSTEP.XMLDoc" />
				<title>Contents</title>
				<link rel="stylesheet" type="text/css" href="css/tree.css" />
				<script src="js/tree.js" type="text/javascript" />
			</head>
			<body id="docBody" style="background-color: #6699CC; color: White; margin: 0px 0px 0px 0px;" onload="resizeTree()" onresize="resizeTree()" onselectstart="return false;">
				<div style="font-family: verdana; font-size: 8pt; cursor: pointer; margin: 6 4 8 2; text-align: right" onmouseover="this.style.textDecoration='underline'" onmouseout="this.style.textDecoration='none'" onclick="syncTree(window.parent.frames[1].document.URL)">sync toc</div>
				<div id="tree" style="top: 35px; left: 0px;" class="treeDiv">
					<xsl:apply-templates/>
				</div>
			</body>
		</html>
	</xsl:template>
	
	<xsl:template match="/UL">
		<div id="treeRoot" onselectstart="return false" ondragstart="return false">
			<xsl:apply-templates select="LI" />
		</div>
	</xsl:template>

	<xsl:template match="LI">
		<div class='treeNode'>
			<xsl:variable name="nextsib" select="following-sibling::*[1]"/>
			
			<xsl:choose>
				<xsl:when test="local-name($nextsib)='UL'">
					<img src="images\treenodeplus.gif" class="treeLinkImage" onclick="expandCollapse(this.parentNode)" />
				</xsl:when>
				<xsl:otherwise>
					<img src="images\treenodedot.gif" class="treeNoLinkImage" />
				</xsl:otherwise>
			</xsl:choose>
			
			<a>
				<xsl:attribute name="href"><xsl:value-of select="./OBJECT/param[@name='Local']/@value"/></xsl:attribute>
				<xsl:attribute name="target">main</xsl:attribute>
				<xsl:attribute name="class">treeUnselected</xsl:attribute>
				<xsl:attribute name="onclick">clickAnchor(this)</xsl:attribute>
				<xsl:value-of select="./OBJECT/param[@name='Name']/@value"/></a>
			
			<xsl:if test="local-name($nextsib)='UL'">
				<xsl:apply-templates select="$nextsib"/>
			</xsl:if>
		</div>
	</xsl:template>

	<xsl:template match="/UL//UL">
		<div class="treeSubnodesHidden">
			<xsl:apply-templates select="LI" />
		</div>
	</xsl:template>

</xsl:stylesheet>
