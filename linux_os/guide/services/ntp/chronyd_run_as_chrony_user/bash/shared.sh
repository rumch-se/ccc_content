# platform = multi_platform_all
{{%- set ok_by_default = false %}}
{{%- if product in ["ol7", "ol8", "ol9", "fedora"] or 'rhel' in product %}}
{{%- set ok_by_default = true %}}
{{%- endif %}}

{{% if ok_by_default -%}}
if grep -q 'OPTIONS=.*' /etc/sysconfig/chronyd; then
	# trying to solve cases where the parameter after OPTIONS
	#may or may not be enclosed in quotes
	sed -i -E -e 's/\s*-u\s*\w+\s*/ /' -e 's/^([\s]*OPTIONS=["]?[^"]*)("?)/\1\2/' /etc/sysconfig/chronyd
fi
{{% else -%}}
{{%- endif %}}
if grep -q 'OPTIONS=.*' /etc/sysconfig/chronyd; then
	# trying to solve cases where the parameter after OPTIONS
	#may or may not be enclosed in quotes
	sed -i -E -e 's/\s*-u\s*\w+\s*/ /' -e 's/^([\s]*OPTIONS=["]?[^"]*)("?)/\1 -u chrony\2/' /etc/sysconfig/chronyd
else
	echo 'OPTIONS="-u chrony"' >> /etc/sysconfig/chronyd
fi
