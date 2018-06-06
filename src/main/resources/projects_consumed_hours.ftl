Dear ${name}

The following projects have consumed more then 50% of hours:

<#list projects as project>
   Project: ${project.project};
   Total Hours: ${project.totalHours}
   Consumed Hours: ${project.consumedHours}
   Consumed Percentage: ${project.consumedPercentage}%
   
</#list>
Thanks

Red Hat Timekeeper Team