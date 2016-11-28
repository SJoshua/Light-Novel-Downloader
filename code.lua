----------------------------------
-- lkDownloader
-- By Joshua
-- At 2013-03-11 12:21:19
----------------------------------
local luacom=require("luacom")
local iconv=require("iconv")
local lfs=require("lfs")
require("lcon")

local togbk=iconv.new("gbk","utf-8")
local toutf=iconv.new("utf-8","gbk")
----------------------------------
-- data
-- By Joshua
-- At 2013-03-11 18:27:31
----------------------------------
local data={
	"vollist",
	"book",
	"view"
}
----------------------------------
-- db
-- By Joshua
-- At 2013-03-11 19:30:16
----------------------------------
local db={
	picid=0
}
----------------------------------
-- cls
-- By Joshua
-- At 2013-03-11 18:28:13
----------------------------------
function cls()
	return os.execute("cls")
end
----------------------------------
-- pgreen
-- By Joshua
-- At 2013-03-11 18:34:07
----------------------------------
function pgreen(...)
	lcon.set_color(11)
	io.write(...)
	lcon.set_color(15)
end
----------------------------------
-- pblue
-- By Joshua
-- At 2013-03-11 19:01:52
----------------------------------
function pblue(...)
	lcon.set_color(9)
	io.write(...)
	lcon.set_color(15)
end
----------------------------------
-- tfbox
-- By Joshua
-- At 2013-03-11 19:03:34
----------------------------------
function tfbox(msg)
	cls()
	local Max=47
	local res={}
	msg=msg.."\n"
	while msg and msg:find("\n") do
		local r=msg:match("^(.-)\n")
		if r:find("^%[.-%]$") then
			table.insert(res,r:match("^%[(.-)%]$"))
		else
			local r=r:gsub("%*","    ")
			table.insert(res,r..(" "):rep(Max-#r))
		end
		msg=msg:match("^.-\n(.+)$")
	end
	io.write("\t=================================================\n")
	for i,v in pairs(res) do
		v=(" "):rep(math.floor((Max-#v)/2))..v
		io.write("\t#",v..(" "):rep(Max-#v),"#\n")
	end
	io.write("\t#\t\t\t\t\t\t#\n\t#\t\t ")
	pgreen("> 是")
	io.write("        否\t\t\t#\n")
	io.write("\t=================================================\n")
	local mouse="left"
	while true do
		local key=lcon.getch()
		if key==75 then
			lcon.gotoXY(25,3)
			pgreen("> 是")
			io.write("        否")
			mouse="left"
		elseif key==77 or key==27 then
			lcon.gotoXY(25,3)
			io.write("  是")
			lcon.gotoXY(35,3)
			pgreen("> 否")
			mouse="right"
		elseif key==13 then
			return mouse=="left"
		end
	end
end
----------------------------------
-- selectbox
-- By Joshua
-- At 2013-03-11 18:30:10
----------------------------------
function selectbox(tip,list)
	cls()
	lcon.set_color(15)
	io.write(tip,"\n")
	io.write("=============================================================\n")
	pgreen("\t\t> ",list[1],"\n")
	for i=2,#list do
		io.write("\t\t  ",list[i],"\n")
	end
	io.write("=============================================================\n")
	local m=#list
	local x=16
	local y=lcon.cur_y()-6
	local point=1
	while true do
		local Key=lcon.getch()
		if Key==72 and point>1 then
			lcon.gotoXY(x,y)
			io.write("  ",list[point])
			point=point-1
			y=y-1
			lcon.gotoXY(x,y)
			pgreen("> ",list[point])
		elseif Key==80 and point<m then
			lcon.gotoXY(x,y)
			io.write("  ",list[point])
			point=point+1
			y=y+1
			lcon.gotoXY(x,y)
			pgreen("> ",list[point])
		elseif Key==13 then
			return point
		end
	end
end
----------------------------------
-- msgbox
-- By Joshua
-- At 2013-03-11 18:44:29
----------------------------------
function msgbox(msg)
	cls()
	for i in msg:gmatch("{(.-)}") do
		local s,e=msg:find("{.-}")
		io.write(msg:sub(1,s-1))
		pblue(i)
		msg=msg:sub(e+1,#msg)
	end
	io.write(msg)
	pgreen("> 确认\n")
	while lcon.getch()~=13 do
	end
end 
----------------------------------
-- main
-- By Joshua
-- At 2013-03-11 18:27:45
----------------------------------
function main(t)
	local id
	db.picid=0
	local res=selectbox("\t--- 欢迎使用轻之在线资源下载器 ---\n\n\t\t=== 菜单 ===\n\n",
		{"下载一个系列",
		 "下载一本小说",
		 "下载一个章节",
		 "版权信息",
		 "退出程序"
		})
	if res==1 then
		while not id do
			cls()
			io.write("请输入系列编号。\n\t -- Tip:\n\t举例《刀剑神域》，该系列地址为\n\t\thttp://lknovel.lightnovel.cn/main/vollist/83.html\n\t则其系列编号为83。系列编号只能为数字。\n\n\t")
			id=tonumber(io.read())
		end
		db.flag=tfbox("[你要下载图片吗？]")
		if db.flag then
			db.ppic=tfbox("[图片要分别存放吗？]")
		end
		db.sta=res
		cls()
		return download(res,id)
	elseif res==2 then
		while not id do
			cls()
			io.write("请输入小说编号。\n\t -- Tip:\n\t举例《刀剑神域·第一部》，该小说地址为\n\t\thttp://lknovel.lightnovel.cn/main/book/161.html\n\t则其小说编号为161。小说编号只能为数字。\n\n\t")
			id=tonumber(io.read())
		end
		db.flag=tfbox("[你要下载图片吗？]")
		db.sta=res
		cls()
		return download(res,id)
	elseif res==3 then
		while not id do
			cls()
			io.write("请输入章节编号。\n\t -- Tip:\n\t举例《刀剑神域·第一部》·序章，该章节地址为\n\t\thttp://lknovel.lightnovel.cn/main/view/1062.html\n\t则其章节编号为1062。章节编号只能为数字。\n\n\t")
			id=tonumber(io.read())
		end
		db.flag=tfbox("[你要下载图片吗？]")
		db.sta=res
		cls()
		return download(res,id)
	elseif res==4 then
		msgbox("\t\t       === 版权信息 ===\n\t\t\t开发 - 约修亚_RK\n\t\t\t出品 - 暗影软件 ({srkf.tk})\n\t\t\t资源 - 轻之在线 ({lknovel.lightnovel.cn})\n\n\t\t声明: 本工具为自由软件，允许修改源代码并且二次发布，\n\t\t      但不允许更改版权信息(包括源代码中的)，\n\t\t      同时二次发布时必须同样开源。\n\n\t\t\t    ")
		return main()
	elseif res==5 then
		return os.exit()
	end
end
----------------------------------
-- getpath
-- By Joshua
-- At 2013-03-11 19:38:25
----------------------------------
function getpath()
	if db.sta==1 then
		return db.path.."\\"..db.unit.."\\"..db.page:gsub("[:%*\\/<>|%?\"]","")..".txt"
	elseif db.sta==2 then
		return db.unit.."\\"..db.page:gsub("[:%*\\/<>|%?\"]","")..".txt"
	elseif db.sta==3 then
		return db.page:gsub("[:%*\\/<>|%?\"]","")..".txt"
	end
end
----------------------------------
-- download
-- By Joshua
-- At 2013-03-11 19:31:55
----------------------------------
function download(id,key)
	if id==1 then
		local res=get(id,key)
		if res:find("<title> %-  %- ") then
			io.write("错误 - 系列不存在。")
			os.execute("pause")
			return main()
		end
		db.path=togbk:iconv(res:match("<li class=\"active\">(.-)</li>")):gsub("[:%*\\/<>|%?\"]",""):match("^%s*(.-)%s*$")
		io.write("正在抓取系列『",db.path,"』\n")
		os.execute("@mkdir \""..db.path.."\"")
		if not db.ppic and db.flag then
			os.execute("@mkdir \""..db.path.."\\pic\"")
		end
		for i in res:gmatch("<h2 class=\"ft%-24\">(.-)</h2>") do
			download(2,i:match("<a href=\"http://lknovel%.lightnovel%.cn/main/book/(%d+).html\">"))
		end
		io.write("系列『",db.path,"』下载完毕\n\n")
		os.execute("pause")
		return main()
	elseif id==2 then
		local res=get(id,key)
		if not res then
			io.write("错误 - 小说不存在。")
			os.execute("pause")
			return main()
		end
		db.unit=togbk:iconv(res:match("<title>.-%- (.-) %-").." - "..res:match("<li class=\"active\">(.-)</li>")):gsub("[:%*\\/<>|%?\"]",""):match("^%s*(.-)%s*$")
		io.write("正在抓取小说『",db.unit,"』\n")
		if db.ppic then 
			db.picid=0
		end
		if db.sta==1 and not db.ppic then
			os.execute("@mkdir \""..db.path.."\\"..db.unit.."\"")
		elseif db.sta==1 then
			os.execute("@mkdir \""..db.path.."\\"..db.unit.."\"")
			os.execute("@mkdir \""..db.path.."\\"..db.unit.."\\pic\"")
		else
			os.execute("@mkdir \""..db.unit.."\"")
			os.execute("@mkdir \""..db.unit.."\\pic\"")
		end
		for i in res:gmatch("<li class=\"span3\">(.-)</li>") do
			download(3,i:match("<a href=\"http://lknovel%.lightnovel%.cn/main/view/(%d+).html\""))
		end
		io.write("小说『",db.unit,"』下载完毕\n")
		if sta==2 then
			io.write("\n")
			os.execute("pause")
			return main()
		end
	elseif id==3 then
		local res=get(id,key)
		if res:find("<a href=\"/main/vollist/%.html\">") then
			io.write("错误 - 章节不存在。")
			os.execute("pause")
			return main()
		end
		local res=res:match("<div id=\"J_view\" class=\"mt%-20\">(.-)<div class=\"text%-center mt%-20\">")
		db.page=togbk:iconv(res:match("<h3 align=\"center\" class=\"ft%-20\">(.-)</h3>")):gsub("[:%*\\/<>|%?\"]",""):match("^%s*(.-)%s*$")
		io.write("正在下载章节『",db.page,"』\n")
		local f=io.open(getpath(),"w")
		f:write(fmtext(res))
		f:close()
		if sta==2 then
			io.write("章节『"..db.page.."』下载完毕\n\n")
			os.execute("pause")
			return main()
		end
	end
end
----------------------------------
-- get
-- By Joshua
-- At 2013-03-11 19:33:12
----------------------------------
function get(c,n)
	local ajax=luacom.CreateObject("msxml2.xmlhttp")
	if c==4 then
		ajax:open("GET ",n,false)
	else
		ajax:open("GET ","http://lknovel.lightnovel.cn/main/"..data[c].."/"..n..".html",false)
	end
	a,b=pcall(ajax.send,ajax)
	if not a then
		cls()
		io.write("网络错误，请检查网络连接。")
		os.execute("pause")
		return main()
	end
	return ajax.responseBody
end
----------------------------------
-- getpic
-- By Joshua
-- At 2013-03-12 12:53:57
----------------------------------
function getpic()
	if db.sta==3 then
		return "pic/"..db.picid..".jpg"
	elseif not db.ppic then
		return db.path.."/pic/"..db.picid..".jpg"
	elseif db.sta==1 then
		return db.path.."/"..db.unit.."/pic/"..db.picid..".jpg"
	elseif db.sta==2 then
		return db.unit.."/pic/"..db.picid..".jpg"
	end
end
----------------------------------
-- fmtext
-- By Joshua
-- At 2013-03-11 19:33:18
----------------------------------
function fmtext(t)
	local r=t
	t=t:gsub("\t","")
	if db.flag then 
		for i in t:gmatch("<img src=\".-\" class=\"J_lazy J_scoll_load\" data%-cover=\"(.-)\" style=\".-\"") do
			db.picid=db.picid+1
			if not i:find("^http") then
				i="http://lknovel.lightnovel.cn"..i
			end
			local s=io.open(getpic(),"wb")
			s:write(get(4,i))
			s:close()
			t=t:gsub("<img.->","[pic "..db.picid.."]",1)
			io.write("『图",db.picid,"』下载完成\n")
		end
	end
	t=t:gsub("<h2.->",""):gsub("<h3.->",""):gsub("<a.->",""):gsub("<h2.->",""):gsub("<img.->",""):gsub("<div.->",""):gsub("</.->",""):gsub("<br.->",""):gsub("<i.->",""):gsub("<hr.->","")
	return t
end
----------------------------------
-- main
-- By Joshua
-- At 2013-03-11 19:34:45
----------------------------------
os.execute("title 轻之在线资源下载器")
lfs.mkdir("pic")
main()
