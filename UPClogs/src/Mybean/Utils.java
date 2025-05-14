package Mybean;

public class Utils 
{
	public static String getSubStr(String s,int num)
	{
		if(s==null||num==0)return"";
		if(s.length()<=num)return s;
		return s.substring(0, num-1);
	}
}
