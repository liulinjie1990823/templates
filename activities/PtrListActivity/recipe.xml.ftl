<?xml version="1.0"?>
<recipe>
    <instantiate from="root/res/layout/ptr_list.xml.ftl"
                 to="${escapeXmlAttribute(resOut)}/layout/${layoutName}.xml" />

    <open file="${escapeXmlAttribute(resOut)}/layout/${layoutName}.xml" />

    <instantiate from="root/src/app_package/PtrListActivity.java.ftl"
                   to="${escapeXmlAttribute(srcOut)}/${activityClass}.java" />

    <open file="${escapeXmlAttribute(srcOut)}/${activityClass}.java" />
</recipe>
