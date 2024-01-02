if ++global.collect >= 20
{
	global.collect = 0;
	other.hp++;
}
instance_destroy();
