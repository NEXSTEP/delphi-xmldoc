<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xmldoc="http://embarcadero.com" >

	<!-- -->
	<xsl:template match="class | struct | interface" mode="members">
		<html dir="LTR">
			<xsl:call-template name="html-head">
				<xsl:with-param name="title" select="concat(@name, ' ', 'Members')" />
			</xsl:call-template>
			<body id="bodyID" class="dtBODY">
				<xsl:variable name="type" select="local-name()"/>
				<xsl:call-template name="title-row">
					<xsl:with-param name="type-name" select="concat(@name, ' ', 'Members')" />
				</xsl:call-template>
				<div id="nstext">
					<xsl:variable name="namespace" select="../@name" />
					<xsl:variable name="metatype" select="local-name()" />
					<xsl:variable name="type" select="@name" />

					<p><xsl:call-template name="get-link-for-type">
						<xsl:with-param name="namespace" select="$namespace" />
						<xsl:with-param name="name" select="$type" />
						<xsl:with-param name="suffix" select="$typeConfigurations/node()[name()=$metatype]/singular" />
					</xsl:call-template>
					<xsl:text> overview</xsl:text></p>

					<xsl:if test="local-name()='class' or local-name()='interface'">
						<h3>Hierarchy</h3>
						<p>
							<xsl:call-template name="draw-hierarchy-members">
								<xsl:with-param name="list" select="ancestor" />
							</xsl:call-template>
							<xsl:call-template name="indent">
								<xsl:with-param name="count" select="xmldoc:hierarchy-level(./ancestor)" />
							</xsl:call-template>
							<b>
								<xsl:value-of  select="concat(../@name, '.', @name)" />
							</b>
						</p>
					</xsl:if>
					
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
					<!--xsl:call-template name="seealso-section" /-->
				        <h3>
			        	    <xsl:value-of select="$sectionConfigurations/node()[name()='seealso']" /> 
				        </h3>
					<p><xsl:call-template name="get-link-for-type">
						<xsl:with-param name="namespace" select="$namespace" />
						<xsl:with-param name="name" select="$type" />
						<xsl:with-param name="suffix" select="$typeConfigurations/node()[name()=$metatype]/singular" />
					   </xsl:call-template>
					<xsl:text> | </xsl:text>
					<xsl:call-template name="get-link-for-namespace">
						<xsl:with-param name="namespace" select="$namespace" />
						<xsl:with-param name="suffix">Unit</xsl:with-param>
					</xsl:call-template></p>
				</div>
			</body>

		</html>
	</xsl:template>

	<xsl:template name="draw-hierarchy-members">
		<xsl:param name="list" />
		<xsl:if test="count($list) &gt; 0">
			<xsl:call-template name="draw-hierarchy-members">
				<xsl:with-param name="list" select="$list/ancestor" />
			</xsl:call-template>

			<xsl:call-template name="indent">
				<xsl:with-param name="count" select="xmldoc:hierarchy-level($list) - 1" />
			</xsl:call-template>
			<xsl:call-template name="get-link-for-type-members">
				<xsl:with-param name="namespace" select="$list/@namespace" />
				<xsl:with-param name="name" select="$list/@name" />
				<xsl:with-param name="include-namespace">1</xsl:with-param>
			</xsl:call-template>
				<!--xsl:value-of select="concat($list/@namespace, '.', $list/@name)" /-->
                        <xsl:value-of disable-output-escaping="yes">&lt;br /&gt;</xsl:value-of>
		</xsl:if>
	</xsl:template>

	<xsl:template name="members-list">
		<xsl:param name="namespace" />
		<xsl:param name="name" />
		<xsl:param name="type" />
		<xsl:param name="nodes" />

		<xsl:variable name="metatype" select="local-name()"/>

		<xsl:apply-templates select="$nodes" mode="members-create" />

		<xsl:call-template name="members-list-int">
			<xsl:with-param name="type" select="$type" />
			<xsl:with-param name="nodes" select="$nodes" />
		</xsl:call-template>

		<xsl:variable name="filename">
			<xsl:call-template name="calc-link-url">
				<xsl:with-param name="namespace" select="$namespace" />
				<xsl:with-param name="name" select="$name" />
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
						<p>For a list of all members of this type, see 
						<xsl:call-template name="get-link-for-type-members">
							<xsl:with-param name="namespace" select="$namespace"/>
							<xsl:with-param name="name" select="$name" />
							<xsl:with-param name="suffix">members</xsl:with-param>
						</xsl:call-template>.</p>

						<xsl:call-template name="members-list-int">
							<xsl:with-param name="type" select="$type"/>
							<xsl:with-param name="nodes" select="$nodes" />
						</xsl:call-template>

					        <h3>
			        		    <xsl:value-of select="$sectionConfigurations/node()[name()='seealso']" /> 
					        </h3>
						<p><xsl:call-template name="get-link-for-type-members">
							<xsl:with-param name="namespace" select="$namespace"/>
							<xsl:with-param name="name" select="$name" />
							<xsl:with-param name="suffix">members</xsl:with-param>
						</xsl:call-template>
						<xsl:text> | </xsl:text>
						<xsl:call-template name="get-link-for-type">
							<xsl:with-param name="namespace" select="$namespace"/>
							<xsl:with-param name="name" select="$name" />
							<xsl:with-param name="suffix" select="$typeConfigurations/node()[name()=$metatype]/singular" />
						</xsl:call-template>
						<xsl:text> | </xsl:text>
						<xsl:call-template name="get-link-for-namespace">
							<xsl:with-param name="namespace" select="$namespace"/>
							<xsl:with-param name="suffix">Unit</xsl:with-param>
						</xsl:call-template></p>
					</div>
				</body>
			</html>
		</xsl:result-document>
	</xsl:template>

	<xsl:template name="members-list-int">
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
					<xsl:apply-templates select="$nodes" mode="members">
						<xsl:sort select="@name" />
					</xsl:apply-templates>
				</table>
			</div>
		</xsl:if>
	</xsl:template>

        <xsl:variable name="membersConfigurations" select="$configurations/members" />

	<xsl:include href="member.xslt" />

	<xsl:template match="constructor | destructor | field | procedure | function | property | event | array | enum | set | pointer | type | classref" mode="members-create">
		<xsl:variable name="filename">
			<xsl:call-template name="get-member-filename" />
		</xsl:variable>

		<xsl:call-template name="create_page">
			<xsl:with-param name="name" select="$filename"/>
			<xsl:with-param name="mode">member</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="constructor | destructor | field | procedure | function | property | event | array | enum | set | pointer | type | classref" mode="members">

		<xsl:variable name="filename">
			<xsl:call-template name="get-member-filename" />
		</xsl:variable>

		<tr valign="top">
			<td width="50%">
				<xsl:variable name="type" select="local-name()" />
				<xsl:variable name="visibility" select="@visibility" />

				<img src="images/{$membersConfigurations/node()[local-name()=$type]/node()[local-name()=$visibility]}" />
				
				<a>
					<xsl:attribute name="href" select="$filename" />
					<xsl:value-of select="@name" />
				</a>
				<xsl:if test="local-name()='methodref'">
					<xsl:text> Inherited from </xsl:text>
					<xsl:value-of select="concat(../@namespace, '.', ../@name)" />
				</xsl:if>
			</td>
			<td width="50%">
				<xsl:apply-templates select="(devnotes/summary)[1]/node()" />
				<xsl:if test="not((devnotes/summary)[1]/node())">&#160;</xsl:if>
			</td>
		</tr>
	</xsl:template>

</xsl:stylesheet>

