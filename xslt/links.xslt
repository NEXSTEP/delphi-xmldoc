<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template name="get-link-for-namespace">
		<xsl:param name="namespace" />
		<xsl:param name="suffix" />
		<a>
			<xsl:attribute name="href">
				<xsl:call-template name="get-filename-for-namespace">
					<xsl:with-param name="namespace" select="$namespace" />
				</xsl:call-template>
			</xsl:attribute>
			<xsl:value-of select="$namespace" />
			<xsl:if test="$suffix">
				<xsl:text> </xsl:text><xsl:value-of select="$suffix" />
			</xsl:if>
		</a>
	</xsl:template>

	<xsl:template name="get-link-for-type">
		<xsl:param name="namespace" />
		<xsl:param name="name" />
		<xsl:param name="id" />
		<xsl:param name="suffix" />
		<xsl:param name="include-namespace" />
		<a>
			<xsl:attribute name="href">
				<xsl:call-template name="get-filename-for-type">
					<xsl:with-param name="namespace" select="$namespace" />
					<xsl:with-param name="name" select="$name" />
					<xsl:with-param name="id" select="$id" />
				</xsl:call-template>
			</xsl:attribute>
			<xsl:if test="$include-namespace">
				+<xsl:value-of select="$namespace" />+
				<xsl:text>.</xsl:text>
			</xsl:if>
			<xsl:value-of select="$name" />
			<xsl:if test="$suffix">
				<xsl:text> </xsl:text><xsl:value-of select="$suffix" />
			</xsl:if>
		</a>
	</xsl:template>

	<xsl:template name="get-link-for-type-members">
		<xsl:param name="namespace" />
		<xsl:param name="name" />
		<xsl:param name="suffix" />
		<xsl:param name="include-namespace" />
		<a>
			<xsl:attribute name="href">
				<xsl:call-template name="get-filename-for-type-members">
					<xsl:with-param name="namespace" select="$namespace" />
					<xsl:with-param name="name" select="$name" />
				</xsl:call-template>
			</xsl:attribute>
			<xsl:if test="$include-namespace">
				<xsl:value-of select="$namespace" />
				<xsl:text>.</xsl:text>
			</xsl:if>
			<xsl:value-of select="$name" />
			<xsl:if test="$suffix">
				<xsl:text> </xsl:text><xsl:value-of select="$suffix" />
			</xsl:if>
		</a>
	</xsl:template>

</xsl:stylesheet>
