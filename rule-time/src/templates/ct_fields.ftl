<#assign aui = PortletJspTagLibs["/META-INF/aui.tld"] />
<#assign liferay_ui = PortletJspTagLibs["/META-INF/liferay-ui.tld"] />
<#assign portlet = PortletJspTagLibs["/META-INF/liferay-portlet.tld"] />

<@portlet["defineObjects"] />

<#setting number_format="computer">

<#assign nowTime = now?time />

<div class="alert alert-info">
	<@liferay_ui["message"] arguments=nowTime?string.short key="this-rule-checks-the-server-time-which-currently-is-x" />
</div>

<div id='<@portlet["namespace"] />incorrectTimeMessage' class="hide alert alert-error">
	<@liferay_ui["message"] key="start-time-later-than-end-time" />
</div>

<@aui["fieldset"] cssClass="time-selector" label="start-time">
	<@liferay_ui["input-time"]
		amPmParam="startTimeAmPm"
		amPmValue=startTimeAmPm
		hourParam="startTimeHour"
		hourValue=startTimeHour
		minuteParam="startTimeMinute"
		minuteValue=startTimeMinute
		name="startTime" />
</@>

<@aui["fieldset"] cssClass="time-selector" label="end-time">
	<@liferay_ui["input-time"]
		amPmParam="endTimeAmPm"
		amPmValue=endTimeAmPm
		hourParam="endTimeHour"
		hourValue=endTimeHour
		minuteParam="endTimeMinute"
		minuteValue=endTimeMinute
		name="endTime"
	/>
</@>

<@aui["script"]>
	var A = new AUI();

	A.all('input[name*="Time"][type="text"]').each(
        function(timeInput) {
            timeInput.on(
                'blur',
                function() {

                    var timeParts = [];

                    A.all('input[name*="Time"][type="hidden"]').each(
                        function(input) {
							var partArray = input.attr('name').split('_');
							var partName = partArray[partArray.length - 1];

							timeParts[partName] = input.val();
						}
					);

					var correctTime = true;

					correctTime = correctTime &&
						Number(timeParts.endTimeAmPm) >= Number(timeParts.startTimeAmPm);
					correctTime = correctTime &&
						Number(timeParts.endTimeHour) >= Number(timeParts.startTimeHour);
					correctTime = correctTime &&
						(Number(timeParts.endTimeHour) > Number(timeParts.startTimeHour) ||
						Number(timeParts.endTimeMinute) >= Number(timeParts.startTimeMinute));

                    if (!correctTime) {
                        A.one('#<@portlet["namespace"] />incorrectTimeMessage').show();
                    }
                    else {
                        A.one('#<@portlet["namespace"] />incorrectTimeMessage').hide();
                    }

                }
            );
        }
	);
</@>

<style>
	.time-selector legend {
		border-width: 0;
		font-weight: bold; font-size: 15px;
		line-height: 30px;
		margin-bottom: 0;
	}
</style>