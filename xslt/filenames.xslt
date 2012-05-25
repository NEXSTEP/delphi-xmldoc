<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template name="get-filename-for-namespace">
		<xsl:param name="namespace" />
		<xsl:call-template name="calc-link-url">
			<xsl:with-param name="namespace" select="$namespace" />
		</xsl:call-template>
	</xsl:template>

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

	<xsl:template name="get-filename-for-type">
		<xsl:param name="namespace" />
		<xsl:param name="name" />
		<xsl:param name="id" />
		<xsl:call-template name="calc-link-url">
			<xsl:with-param name="namespace" select="$namespace" />
			<xsl:with-param name="name" select="$name" />
			<xsl:with-param name="suffix" select="$id" />
		</xsl:call-template>
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
				<xsl:value-of select="$namespace" />
				<xsl:text>.</xsl:text>
			</xsl:if>
			<xsl:value-of select="$name" />
			<xsl:if test="$suffix">
				<xsl:text> </xsl:text><xsl:value-of select="$suffix" />
			</xsl:if>
		</a>
	</xsl:template>


	<xsl:template name="get-filename-for-type-members">
		<xsl:param name="namespace" />
		<xsl:param name="name" />

		<xsl:call-template name="calc-link-url">
			<xsl:with-param name="namespace" select="$namespace" />
			<xsl:with-param name="name" select="$name" />
			<xsl:with-param name="suffix">Members</xsl:with-param>
		</xsl:call-template>
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

	<xsl:template name="get-member-filename">
		<xsl:call-template name="get-filename-for-type">
			<xsl:with-param name="namespace" >
				<xsl:choose>
					<xsl:when test="../local-name()='interface' or ../local-name()='struct'">
						<xsl:value-of select="../../@name" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="../../../@name" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
			<xsl:with-param name="name" >
				<xsl:choose>
					<xsl:when test="../local-name()='interface' or ../local-name()='struct'">
						<xsl:value-of select="concat(../@name, '.', @name)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="concat(../../@name, '.', @name)" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
			<xsl:with-param name="id">
				<xsl:if test="local-name()='constructor' or ((local-name()='destructor' or local-name()='procedure' or local-name()='function') and contains(@procflags, 'overload'))">
					<xsl:value-of select="generate-id(./node())" />
				</xsl:if>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="get-cref-to-href">
		<xsl:param name="cref" />
		<xsl:variable name="namespace">
			<xsl:call-template name="get-namespace">
				<xsl:with-param name="name" select="substring-after($cref, ':')" />
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="name">
			<xsl:call-template name="strip-namespace">
				<xsl:with-param name="name" select="substring-after($cref, ':')" />
			</xsl:call-template>
		</xsl:variable>
		<xsl:call-template name="calc-link-url">
			<xsl:with-param name="namespace" select="$namespace" />
			<xsl:with-param name="name" select="$name" />
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="get-namespace">
		<xsl:param name="name" />
		<xsl:param name="namespace" />
		<xsl:choose>
			<xsl:when test="contains($name, '.')">
				<xsl:call-template name="get-namespace">
					<xsl:with-param name="name" select="substring-after($name, '.')" />
					<xsl:with-param name="namespace" select="concat($namespace, substring-before($name, '.'), '.')" />
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="substring($namespace, 1, string-length($namespace) - 1)" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="strip-namespace">
		<xsl:param name="name" />
		<xsl:choose>
			<xsl:when test="contains($name, '.')">
				<xsl:call-template name="strip-namespace">
					<xsl:with-param name="name" select="substring-after($name, '.')" />
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$name" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="calc-link-url">
		<xsl:param name="namespace" />
		<xsl:param name="name" />
		<xsl:param name="suffix" />
		<xsl:choose>
			<xsl:when test="starts-with($namespace, 'System') and normalize-space($name)">
				<xsl:value-of select="concat('http://docwiki.embarcadero.com/Libraries/en/',$namespace, '.', $name)" />
			</xsl:when>
			<xsl:when test="starts-with($namespace, 'System')">
				<xsl:value-of select="concat('http://docwiki.embarcadero.com/Libraries/en/',$namespace)" />
			</xsl:when>
			<xsl:when test="normalize-space($name) and normalize-space($suffix)">
				<xsl:value-of select="translate(concat($namespace, '.', $name, '.', $suffix, '.html'), &quot;'`&quot;, '_')" />
			</xsl:when>
			<xsl:when test="normalize-space($suffix)">
				<xsl:value-of select="translate(concat($namespace, '.', $suffix, '.html'), &quot;'`&quot;, '_')" />
			</xsl:when>
			<xsl:when test="normalize-space($name)">
				<xsl:value-of select="translate(concat($namespace, '.', $name, '.html'), &quot;'`&quot;, '_')" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="translate(concat($namespace, '.html'), &quot;'`&quot;, '_')" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
