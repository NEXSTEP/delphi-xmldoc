<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<!-- -->
	<xsl:output method="xml" indent="yes"  encoding="utf-8" />

	<!-- -->
	<xsl:include href="common.xslt" />
	<xsl:include href="filenames.xslt" />
	<!--xsl:include href="tags.xslt" /-->

	<!-- -->
	<xsl:template match="/">
		<xsl:apply-templates select="namespace"/>
	</xsl:template>

	<!-- -->
	<xsl:template match="namespace">
		<!--LI>
			<OBJECT type="text/sitemap"> 
		               <param name="Name">
					<xsl:attribute name="value">
						<xsl:value-of select="@name" />
					</xsl:attribute>
			       </param>
			</OBJECT>
		</LI-->
		<!-- Unit members groups (e.g. 'Procedures & Functions') -->
		<UL>
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
		</UL>
	</xsl:template>

	<!-- Unit member groups -->
	<xsl:template name="type-list">
		<xsl:param name="type" />
		<xsl:param name="nodes">
		<!--xsl:copy-of select="./node()[name()=$type]"/-->
		</xsl:param>

		<xsl:if test="$nodes">
			<!-- unit members group name (e.g. 'Procedures & Functions') -->
			<LI>
				<OBJECT type="text/sitemap"> 
			               <param name="Name">
						<xsl:attribute name="value">
							<xsl:value-of select="$type" />
						</xsl:attribute>
				       </param>
			               <param name="Local">
						<xsl:attribute name="value">
							<xsl:call-template name="calc-link-url">
								<xsl:with-param name="namespace" select="@name" />
								<xsl:with-param name="suffix" select="$type" />
							</xsl:call-template>
						</xsl:attribute>
				       </param>
				</OBJECT>
			</LI>
			<!-- group members -->
			<UL>
				<xsl:apply-templates select="$nodes">
					<xsl:sort select="@name" />
				</xsl:apply-templates>
			</UL>
		</xsl:if>
	</xsl:template>

	<!-- group member (e.g. TMyCoolObject class or CoolProc function) -->
	<xsl:template match="class | struct | interface | procedure | function | const | variable | type | pointer | array | enum | set | classref">
		<xsl:variable name="namespace" select="../@name" />
		<xsl:variable name="metatype" select="local-name()" />
		<xsl:variable name="type" select="@name" />
	
		<!-- group member name (e.g. 'TMyCoolObject class') -->
		<LI>
			<OBJECT type="text/sitemap"> 
		               <param name="Name">
					<xsl:attribute name="value">
						<xsl:value-of select="$type" />
						<xsl:text> </xsl:text>
						<xsl:value-of select="$typeConfigurations/node()[name()=$metatype]/singular" />
					</xsl:attribute>
			       </param>
		               <param name="Local">
					<xsl:attribute name="value">
						<xsl:call-template name="get-filename-for-type">
							<xsl:with-param name="namespace" select="$namespace" />
							<xsl:with-param name="name" select="$type" />
							<xsl:with-param name="id">
								<xsl:if test="(local-name()='procedure' or local-name()='function') and contains(@procflags, 'overload')">
									<xsl:value-of select="generate-id(./node())" />
								</xsl:if>
                		                        </xsl:with-param>
						</xsl:call-template>
					</xsl:attribute>
			       </param>
			</OBJECT>
		</LI>

		<xsl:if test="local-name()='class'or local-name()='interface' or local-name()='struct'">
		<UL>
		<!-- link to class/record/interface members -->
		<LI>
			<OBJECT type="text/sitemap"> 
		               <param name="Name">
					<xsl:attribute name="value">
						<xsl:value-of select="$type" /><xsl:text> Members</xsl:text>
						</xsl:attribute>
			       </param>
		               <param name="Local">
					<xsl:attribute name="value">
						<xsl:call-template name="get-filename-for-type-members">
							<xsl:with-param name="namespace" select="$namespace" />
							<xsl:with-param name="name" select="$type" />
							<!--xsl:with-param name="suffix" select="$type" /-->
						</xsl:call-template>
					</xsl:attribute>
			       </param>
			</OBJECT>
		</LI>

		<!-- class/record/interface member groups (e.g. Methods, Properties, etc) -->
		<xsl:choose>
			<xsl:when test="local-name()='class'">
				<xsl:call-template name="members-list">
					<xsl:with-param name="namespace" select="$namespace" />
					<xsl:with-param name="name" select="$type" />
					<xsl:with-param name="type">Constructors &amp; Destructors</xsl:with-param>
					<xsl:with-param name="nodes" select="members/constructor[@visibility='published' or @visibility='public' or @visibility='protected'] | members/destructor[@visibility='published' or @visibility='public' or @visibility='protected']" />
				</xsl:call-template>
				<xsl:call-template name="members-list">
					<xsl:with-param name="namespace" select="$namespace" />
					<xsl:with-param name="name" select="$type" />
					<xsl:with-param name="type">Types</xsl:with-param>
					<xsl:with-param name="nodes" select="members/type[@visibility='published' or @visibility='public' or @visibility='protected'] | members/array[@visibility='published' or @visibility='public' or @visibility='protected'] | members/enum[@visibility='published' or @visibility='public' or @visibility='protected'] | members/pointer[@visibility='published' or @visibility='public' or @visibility='protected'] | members/classref[@visibility='published' or @visibility='public' or @visibility='protected'] | members/set[@visibility='published' or @visibility='public' or @visibility='protected']" />
				</xsl:call-template>
				<xsl:call-template name="members-list">
					<xsl:with-param name="namespace" select="$namespace" />
					<xsl:with-param name="name" select="$type" />
					<xsl:with-param name="type">Fields</xsl:with-param>
					<xsl:with-param name="nodes" select="members/field[@visibility='published' or @visibility='public' or @visibility='protected']" />
				</xsl:call-template>
				<xsl:call-template name="members-list">
					<xsl:with-param name="namespace" select="$namespace" />
					<xsl:with-param name="name" select="$type" />
					<xsl:with-param name="type">Methods</xsl:with-param>
					<xsl:with-param name="nodes" select="members/procedure[@visibility='published' or @visibility='public' or @visibility='protected'] | members/function[@visibility='published' or @visibility='public' or @visibility='protected']" />
				</xsl:call-template>
				<xsl:call-template name="members-list">
					<xsl:with-param name="namespace" select="$namespace" />
					<xsl:with-param name="name" select="$type" />
					<xsl:with-param name="type">Properties</xsl:with-param>
					<xsl:with-param name="nodes" select="members/property[@visibility='published' or @visibility='public' or @visibility='protected']" />
				</xsl:call-template>
				<xsl:call-template name="members-list">
					<xsl:with-param name="namespace" select="$namespace" />
					<xsl:with-param name="name" select="$type" />
					<xsl:with-param name="type">Events</xsl:with-param>
					<xsl:with-param name="nodes" select="members/event[@visibility='published' or @visibility='public' or @visibility='protected']" />
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="members-list">
					<xsl:with-param name="namespace" select="$namespace" />
					<xsl:with-param name="name" select="$type" />
					<xsl:with-param name="type">Fields</xsl:with-param>
					<xsl:with-param name="nodes" select="field[@visibility='published' or @visibility='public' or @visibility='protected']" />
				</xsl:call-template>
				<xsl:call-template name="members-list">
					<xsl:with-param name="namespace" select="$namespace" />
					<xsl:with-param name="name" select="$type" />
					<xsl:with-param name="type">Methods</xsl:with-param>
					<xsl:with-param name="nodes" select="procedure[@visibility='published' or @visibility='public' or @visibility='protected'] | function[@visibility='published' or @visibility='public' or @visibility='protected']" />
				</xsl:call-template>
				<xsl:call-template name="members-list">
				<xsl:with-param name="namespace" select="$namespace" />
					<xsl:with-param name="name" select="$type" />
					<xsl:with-param name="type">Properties</xsl:with-param>
					<xsl:with-param name="nodes" select="property[@visibility='published' or @visibility='public' or @visibility='protected']" />
				</xsl:call-template>
				<xsl:call-template name="members-list">
					<xsl:with-param name="namespace" select="$namespace" />
					<xsl:with-param name="name" select="$type" />
					<xsl:with-param name="type">Events</xsl:with-param>
					<xsl:with-param name="nodes" select="event[@visibility='published' or @visibility='public' or @visibility='protected']" />
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
		</UL>
		</xsl:if>
	</xsl:template>

	<!-- class/record/interface members -->
	<xsl:template name="members-list">
		<xsl:param name="namespace" />
		<xsl:param name="name" />
		<xsl:param name="type" />
		<xsl:param name="nodes" />

		<xsl:if test="$nodes">
		<LI>
			<OBJECT type="text/sitemap"> 
		               <param name="Name">
					<xsl:attribute name="value">
						<xsl:value-of select="$type" />
					</xsl:attribute>
			       </param>
		               <param name="Local">
					<xsl:attribute name="value">
						<xsl:call-template name="calc-link-url">
							<xsl:with-param name="namespace" select="$namespace" />
							<xsl:with-param name="name" select="$name" />
							<xsl:with-param name="suffix" select="$type" />
						</xsl:call-template>
					</xsl:attribute>
			       </param>
			</OBJECT>
		</LI>
		<UL>
			<xsl:apply-templates select="$nodes" mode="member" />
		</UL>
		</xsl:if>
	</xsl:template>

	<xsl:template match="constructor | destructor | procedure | function | const | field | event | array | type | enum | set | pointer | property" mode="member">
		<xsl:variable name="metatype" select="local-name()" />
		<LI>
			<OBJECT type="text/sitemap"> 
		               <param name="Name">
					<xsl:attribute name="value">
						<xsl:value-of select="@name" />
						<xsl:text> </xsl:text>
						<xsl:value-of select="$typeConfigurations/node()[name()=$metatype]/singular" />
					</xsl:attribute>
			       </param>
		               <param name="Local">
					<xsl:attribute name="value">
						<xsl:call-template name="get-member-filename" />
					</xsl:attribute>
			       </param>
			</OBJECT>
		</LI>
	</xsl:template>
	<!-- -->
</xsl:stylesheet>
