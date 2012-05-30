<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="1.0"
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:msxsl="urn:schemas-microsoft-com:xslt"
 xmlns:ext="http://exslt.org/common"
  exclude-result-prefixes="ext msxsl"
>
	<!-- -->
	<xsl:output method="html" indent="yes"  encoding="utf-8" omit-xml-declaration="yes"/>

	<!-- -->
	<xsl:include href="common.xslt" />
	<xsl:include href="filenames.xslt" />
	<xsl:include href="sections.xslt" />
	<xsl:include href="tags.xslt" /> 

	<!-- -->
	<xsl:template match="/">
		<xsl:apply-templates select="namespace" mode="namespace" />
	</xsl:template>

	<xsl:template match="/" mode="namespace">
		<xsl:result-document href="{namespace/@name}.html">
			<xsl:apply-templates select="namespace" mode="namespace" />
		</xsl:result-document>
	</xsl:template>

	<!-- -->
	<xsl:template match="namespace" mode="namespace">
		<html dir="LTR">
			<xsl:call-template name="html-head">
				<xsl:with-param name="title" select="@name" />
			</xsl:call-template>
			<body id="bodyID" class="dtBODY">
				<xsl:call-template name="title-row">
					<xsl:with-param name="type-name">
						<xsl:value-of select="@name" />
						<xsl:text> Unit</xsl:text>
					</xsl:with-param>
				</xsl:call-template>
				<div id="nstext">
					<!-- the namespace template just gets the summary. -->
					<!--xsl:apply-templates select="(assembly/module/namespace[(@name=$namespace) and documentation])[1]" /-->
					<!--xsl:apply-templates select="devnotes/node()" /-->
					<xsl:call-template name="summary-section" />
				
					<xsl:call-template name="type-list">
						<xsl:with-param name="type">Interfaces</xsl:with-param>
						<xsl:with-param name="nodes" select="interface" />
					</xsl:call-template>
					<xsl:call-template name="type-list">
						<xsl:with-param name="type">Classes</xsl:with-param>
						<xsl:with-param name="nodes" select="class" />
					</xsl:call-template>
					<xsl:call-template name="type-list">
						<xsl:with-param name="type">Records</xsl:with-param>
						<xsl:with-param name="nodes" select="struct" />
					</xsl:call-template>
					<xsl:call-template name="type-list">
						<xsl:with-param name="type">Types</xsl:with-param>
						<xsl:with-param name="nodes" select="type | pointer | array | enum | set | classref" />
					</xsl:call-template>
					<xsl:call-template name="type-list">
						<xsl:with-param name="type">Procedures &amp; Functions</xsl:with-param>
						<xsl:with-param name="nodes" select="procedure | function" />
					</xsl:call-template>
					<xsl:call-template name="type-list">
						<xsl:with-param name="type">Variables &amp; Constants</xsl:with-param>
						<xsl:with-param name="nodes" select="variable | const" />
					</xsl:call-template>

					<xsl:call-template name="remarks-section" />
					<xsl:call-template name="example-section" />
					<xsl:call-template name="comments-section" />
					<xsl:call-template name="seealso-section" />
				</div>
				<hr />
			</body>

		</html>
	</xsl:template>

	<xsl:template name="type-list">
		<xsl:param name="type" />
		<xsl:param name="nodes" />

		<xsl:call-template name="type-list-int">
			<xsl:with-param name="type" select="$type"/>
			<xsl:with-param name="nodes" select="$nodes"/>
		</xsl:call-template>

		<xsl:apply-templates select="$nodes" mode="type-create" />

		<xsl:variable name="filename">
			<xsl:call-template name="calc-link-url">
				<xsl:with-param name="namespace" select="@name" />
				<xsl:with-param name="suffix" select="$type" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:result-document href="{$filename}">
			<html dir="LTR">
				<xsl:call-template name="html-head">
					<xsl:with-param name="title" select="@name" />
				</xsl:call-template>
				<body id="bodyID" class="dtBODY">
					<xsl:call-template name="title-row">
						<xsl:with-param name="type-name" select="concat(@name, ' ', $type)" />
					</xsl:call-template>
					<div id="nstext">
						<p>For a list of all members of this unit, see 
							<xsl:call-template name="get-link-for-namespace">
								<xsl:with-param name="namespace" select="@name"/>
							</xsl:call-template> Unit.</p>
						<xsl:call-template name="type-list-int">
							<xsl:with-param name="type" select="$type"/>
							<xsl:with-param name="nodes" select="$nodes" />
						</xsl:call-template>
					        <h3>
			        		    <xsl:value-of select="$sectionConfigurations/node()[name()='seealso']" /> 
					        </h3>
						<xsl:call-template name="get-link-for-namespace">
							<xsl:with-param name="namespace" select="@name"/>
							<xsl:with-param name="suffix">Unit</xsl:with-param>
						</xsl:call-template>
					</div>
				</body>
			</html>
		</xsl:result-document>
	</xsl:template>

	<xsl:template name="type-list-int">
		<xsl:param name="type" />
		<xsl:param name="nodes" />

		<xsl:if test="$nodes">
			<h3 class="dtH3"><xsl:value-of select="$type" /></h3>
			<div class="tablediv">
				<table class="dtTABLE" cellspacing="0">
					<tr valign="top">
						<th width="50%">Name</th>
						<th width="50%">Description</th>
					</tr>
					<xsl:apply-templates select="$nodes">
						<xsl:sort select="@name" />
					</xsl:apply-templates>
				</table>
			</div>
		</xsl:if>
	</xsl:template>


	<!--xsl:template match="enumeration | delegate | structure | interface | class"-->
	<xsl:include href="type.xslt" />
	<xsl:include href="members.xslt" />

	<xsl:template match="class | struct | interface | procedure | function | const | variable | type | pointer | array | enum | set | classref" mode="type-create">

		<xsl:call-template name="create_page">
			<xsl:with-param name="name">
				<xsl:call-template name="get-filename-for-type">
					<xsl:with-param name="namespace" select="../@name" />
					<xsl:with-param name="name" select="@name" />
					<xsl:with-param name="id">
						<xsl:if test="(local-name()='procedure' or local-name()='function') and contains(@procflags, 'overload')">
							<xsl:value-of select="generate-id(./node())" />
						</xsl:if>
                                        </xsl:with-param>
				</xsl:call-template>
			</xsl:with-param>
			<xsl:with-param name="mode">type</xsl:with-param>
		</xsl:call-template>

		<xsl:if test="local-name()='class' or local-name()='interface' or local-name()='struct'">
			<xsl:call-template name="create_page">
				<xsl:with-param name="name">
					<xsl:call-template name="get-filename-for-type-members">
						<xsl:with-param name="namespace" select="../@name" />
						<xsl:with-param name="name" select="@name" />
					</xsl:call-template>
				</xsl:with-param>
				<xsl:with-param name="mode">members</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>


	<xsl:template match="class | struct | interface | procedure | function | const | variable | type | pointer | array | enum | set | classref">
		<tr valign="top">
			<td width="50%">
				<xsl:call-template name="get-link-for-type">
					<xsl:with-param name="namespace" select="../@name" />
					<xsl:with-param name="name" select="@name" />
					<xsl:with-param name="id">
						<xsl:if test="(local-name()='procedure' or local-name()='function') and contains(@procflags, 'overload')">
							<xsl:value-of select="generate-id(./node())" />
						</xsl:if>
                                        </xsl:with-param>
				</xsl:call-template>
			</td>
			<td width="50%">
				<xsl:apply-templates select="(devnotes/summary)[1]/node()" />
				<xsl:if test="not((devnotes/summary)[1]/node())">&#160;</xsl:if>
			</td>
		</tr>
	</xsl:template>

	<!-- -->
</xsl:stylesheet>
