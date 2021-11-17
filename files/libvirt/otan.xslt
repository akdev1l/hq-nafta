<?xml version="1.0" ?>
<xsl:stylesheet version="1.0"
    xmlns:qemu="http://libvirt.org/schemas/domain/qemu/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output omit-xml-declaration="yes" indent="yes"/>
    <!-- Identity copy -->
    <xsl:template match="node()|@*">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
        </xsl:copy>
    </xsl:template>

    <!-- Add pipewire environment variables -->
    <xsl:template match="/domain">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()" />
            <qemu:commandline>
                <qemu:env name="PIPEWIRE_RUNTIME_DIR" value="/run/user/1000"/>
                <qemu:env name="PIPEWIRE_LATENCY" value="512/48000"/>
            </qemu:commandline>
        </xsl:copy>
    </xsl:template>


    <!-- Add portgroup="vlan-7" -->
    <xsl:template match="/domain/devices/interface[@type='network']/source[@network='bridgenet']">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()" />
            <xsl:attribute name="portgroup">vlan-5</xsl:attribute>
        </xsl:copy>
    </xsl:template>

    <!-- Add passthrough host devices -->
    <xsl:template match="/domain/devices">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()" />
            <disk type="file" device="cdrom">
                <driver name="qemu" type="raw"/>
                <source file="/var/lib/workshop/current/libvirt/images/fedora.iso" />
                <target dev="sdb" bus="sata"/>
                <boot order="1" />
                <readonly/>
                <address type="drive" controller="0" bus="0" target="0" unit="1"/>
            </disk>
            <audio id="1" type="jack">
                <input clientName="otan.hq.akdev.xyz" connectPorts="Razer Kraken X USB Analog Stereo"/>
                <output clientName="otan.hq.akdev.xyz" connectPorts="Razer Kraken X USB Analog Stereo"/>
            </audio>
            <input type="evdev">
                <source dev="/dev/input/by-id/usb-SONiX_USB_DEVICE-event-kbd" grab="all" repeat="on"/>
            </input>
            <input type="evdev">
                <source dev="/dev/input/by-id/usb-04d9_USB_Gaming_Mouse-event-mouse"/>
            </input>
            <hostdev mode="subsystem" type="pci" managed="yes">
                <source>
                    <address domain="0x0000" bus="0x2d" slot="0x00" function="0x0"/>
                </source>
                <address type="pci" domain="0x0000" bus="0x06" slot="0x01" function="0x0"/>
            </hostdev>
            <hostdev mode="subsystem" type="pci" managed="yes">
                <source>
                    <address domain="0x0000" bus="0x2d" slot="0x00" function="0x1"/>
                </source>
                <address type="pci" domain="0x0000" bus="0x07" slot="0x01" function="0x0"/>
            </hostdev>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>
