$(function()
{
	$("dd:not(:first)").hide();
	$("dt a").click(function()
		{
			$("dd").slideUp("fast");
			$(this).parent("dt").next("dd").slideDown("fast");
		});

});
