<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xmldoc="http://embarcadero.com" >

	<!-- -->
	<!--xsl:template match="class | struct | interface | procedure | function | const | variable | type" mode="member"-->
	<xsl:template match="constructor | destructor | procedure | function | const | field | event | array | type | enum | set | pointer | property" mode="member">
		<html dir="LTR">
			<xsl:call-template name="html-head">
				<xsl:with-param name="title" select="@name" />
			</xsl:call-template>
			<body id="bodyID" class="dtBODY">
				<xsl:variable name="namespace" select="../../../@name" />
				<xsl:variable name="namespace">
					<xsl:choose>
						<xsl:when test="../local-name()='members'">
							<xsl:value-of select="../../../@name" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="../../@name" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="type">
					<xsl:choose>
						<xsl:when test="../local-name()='members'">
							<xsl:value-of select="../../@name" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="../@name" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<xsl:variable name="parent-metatype">
					<xsl:choose>
						<xsl:when test="../local-name()='members'">
							<xsl:value-of select="../../local-name()" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="../local-name()" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="metatype" select="local-name()"/>
				<xsl:call-template name="title-row">
					<xsl:with-param name="type-name" select="concat($type, '.', @name, ' ', $typeConfigurations/node()[name()=$metatype]/singular)" />
				</xsl:call-template>
				<div id="nstext">
					<xsl:call-template name="summary-section" />

					<xsl:call-template name="syntax-section" />

					<xsl:call-template name="parameters-section" />
					<xsl:call-template name="returns-section" />

					<xsl:call-template name="remarks-section" />
					<xsl:call-template name="exceptions-section" />
					<xsl:call-template name="example-section" />
					<xsl:call-template name="comments-section" />
					<!--xsl:call-template name="seealso-section" /-->
				        <h3>
			        	    <xsl:value-of select="$sectionConfigurations/node()[name()='seealso']" /> 
				        </h3>
					<p><xsl:call-template name="get-link-for-type-members">
						<xsl:with-param name="namespace" select="$namespace" />
						<xsl:with-param name="name" select="$type" />
						<xsl:with-param name="suffix">members</xsl:with-param>
					</xsl:call-template>
					<xsl:text> | </xsl:text>
					<xsl:call-template name="get-link-for-type">
						<xsl:with-param name="namespace" select="$namespace" />
						<xsl:with-param name="name" select="$type" />
						<xsl:with-param name="suffix" select="$typeConfigurations/node()[name()=$parent-metatype]/singular" />
					</xsl:call-template>
					<xsl:text> | </xsl:text>
					<xsl:call-template name="get-link-for-namespace">							
						<xsl:with-param name="namespace" select="$namespace" />
						<xsl:with-param name="suffix">Unit</xsl:with-param>
					</xsl:call-template></p>
				</div>
				<div>
				<hr />
				</div>
			</body>

		</html>
	</xsl:template>
</xsl:stylesheet>
