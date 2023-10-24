currentSink=$(ponymix defaults | awk -F '[ :]' '/sink/ {print $2}')
if [[ $currentSink = 48 ]]; then
	ponymix -d 47 set-default
else
	ponymix -d 48 set-default
fi

echo Default device set to $currentSink
