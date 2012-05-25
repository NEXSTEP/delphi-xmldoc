<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- Pass through most common html tags -->
<xsl:template match="p|ol|ul|li|dl|dt|dd|table|tr|th|td|a|img|b|i|strong|em|del|sub|sup|br|hr|h1|h2|h3|h4|h5|h6|pre|div|span|blockquote|abbr|acronym|u|font|map|area">
	<xsl:copy>
		<xsl:copy-of select="@*" />
		<xsl:apply-templates />
	</xsl:copy>
</xsl:template>


<xsl:template name="see-cref" match="see[@cref]">
	<a>
		<xsl:attribute name="href">
			<xsl:call-template name="get-cref-to-href">
				<xsl:with-param name="cref" select="@cref" />
			</xsl:call-template>
		</xsl:attribute>
		<xsl:attribute name="title">
			<xsl:value-of select="translate(substring-after(@cref, ':'), '{}', '.&lt;&gt;')" />
		</xsl:attribute>
		<xsl:choose>
			<xsl:when test="normalize-space(.)">
				<xsl:value-of select="." />
			</xsl:when>
      <!--xsl:when test="contains(@cref, '|')">
				<xsl:value-of select="translate(substring-after(@cref, '|'), '{}', '&lt;&gt;')" />
			</xsl:when-->
			<xsl:otherwise>
        <xsl:value-of select="translate(substring-after(@cref, ':'), '{}', '.&lt;&gt;')" />
      </xsl:otherwise>
		</xsl:choose>
    </a>
</xsl:template>

<xsl:template name="see-href" match="see[@href]">
    <a target="_blank" href="{@href}" title="{@href}">
        <xsl:choose>
            <xsl:when test="normalize-space(.)">
                <xsl:value-of select="." />
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="@href" />
            </xsl:otherwise>
        </xsl:choose></a>
</xsl:template>

<xsl:template match="para">
	<p>
    	<xsl:apply-templates />
	</p>
</xsl:template>

<xsl:template match="code">
    <div class="code">
        <table>
            <thead>
            <tr>
                <th>
                    <xsl:value-of select="@lang" />
                </th>
            </tr>
            </thead>
            <tbody>
                <tr>
                    <td>
		        <pre class="code"><xsl:apply-templates /></pre>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>
</xsl:template>



<xsl:template match="list[@type='bullet']">
    <ul>
        <xsl:for-each select="item">
            <li>
                <xsl:apply-templates />
            </li>
        </xsl:for-each>
    </ul>
</xsl:template>

<xsl:template match="list[@type='number']">
    <ol>
        <xsl:for-each select="item">
            <li>
                <xsl:apply-templates />
            </li>
        </xsl:for-each>
    </ol>
</xsl:template>

<xsl:template match="list[@type='table']">
    <table cellspacing="0">
        <xsl:if test="listheader">
            <thead>
                <tr>
                    <th><xsl:value-of select="listheader/term" /></th>
                    <th><xsl:value-of select="listheader/description" /></th>
                </tr>
            </thead>
        </xsl:if>
        <tbody>
            <xsl:for-each select="item">
                <tr>
                    <td><p><xsl:apply-templates select="term/node()" /></p></td>
                    <td><p><xsl:apply-templates select="description/node()" /></p></td>
                </tr>
            </xsl:for-each>
        </tbody>
    </table>
</xsl:template>

<xsl:template match="note">
    <xsl:variable name="value" select="@type" />
    <xsl:variable name="option" select="$noteConfigurations/node()[name()=$value]" />

    <div class="note">
        <table>
            <thead>
            <tr>
                <th>
                    <img src="{concat('images\', $option/iconUri)}" class="note" title="Note" />
                    <span class="note"><xsl:value-of select="$option/title" /></span>
                </th>
            </tr>
            </thead>
            <tbody>
                <tr>
                    <td>
                        <div>
                            <xsl:choose>
                                <xsl:when test="para|p">
                                    <xsl:apply-templates />
                                </xsl:when>
                                <xsl:otherwise>
                                    <p>
                                        <xsl:apply-templates />
                                    </p>
                                </xsl:otherwise>
                            </xsl:choose>
                        </div>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>



</xsl:template>

<xsl:template name="insertNote">
    <xsl:param name="type" />
    <xsl:param name="iconUri" />
    <xsl:param name="title" select="'Note:'" />

    <div class="note">
        <table>
            <thead>
            <tr>
                <th>
                    <img src="{$iconUri}" class="note" title="Note" />
                    <span class="note"><xsl:value-of select="$title" /></span>
                </th>
            </tr>
            </thead>
            <tbody>
                <tr>
                    <td>
                        <div>
                            <xsl:choose>
                                <xsl:when test="para|p">
                                    <xsl:apply-templates />
                                </xsl:when>
                                <xsl:otherwise>
                                    <p>
                                        <xsl:apply-templates />
                                    </p>
                                </xsl:otherwise>
                            </xsl:choose>
                        </div>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>
</xsl:template>


<xsl:template match="c">
	<tt class="inlineCode">
		<xsl:apply-templates/>
	</tt>
</xsl:template>

<xsl:template match="paramref">
	<span class="paramref">
		<xsl:value-of select="@name"/>
	</span>
</xsl:template>

<xsl:template match="typeparamref">
	<span class="typeparamref">
		<xsl:value-of select="@name"/>
	</span>
</xsl:template>

</xsl:stylesheet>
