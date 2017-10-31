function execute ($cmd)
{
	docker run --rm -it `
	-e AWS_PROFILE=$Env:AWS_PROFILE `
	-e AWS_REGION=$Env:AWS_REGION `
	-e AWS_ACCESS_KEY_ID=$Env:AWS_ACCESS_KEY `
	-e AWS_SECRET_ACCESS_KEY_ID=$Env:AWS_SECRET_ACCESS_KEY `
	-e AWS_SESSION_TOKEN=$Env:AWS_SESSION_TOKEN `
	-e USER=$Env:USER `
	-v c:/$($("$(pwd)".Substring(3)) -replace "\\","/"):/module `
	-v c:/$($("$Env:USERPROFILE".Substring(3)) -replace "\\","/")/.aws:/root/.aws:ro `
	-v c:/$($("$Env:USERPROFILE".Substring(3)) -replace "\\","/")/.netrc:/root/.netrc:ro `
	qualimente/terraform-spec:0.9.11 `
	kitchen $cmd $Env:KITCHEN_OPTS
}

foreach ($cmd in $args)
{
	switch ($cmd)
	{
		format
		{
			docker run --rm -it `
			-v c:/$($("$(pwd)".Substring(3)) -replace "\\","/"):/module `
			qualimente/terraform-spec:0.9.11 `
			terraform fmt
		}
		converge {execute($cmd)}
		verify   {execute($cmd)}
		destroy  {execute($cmd)}
		test 	 {execute($cmd)}
		kitchen  {execute($Env:COMMAND)}
		default  {"Invalid argument: $cmd"}
	}
}