----------------------------------
-- lkDownloader
-- By Joshua
-- At 2013-03-11 12:21:19
----------------------------------
-- �������ɰ�Ӱ��ɭ���������(http://srkf.tk)����
-- ������ Լ����_RK
----------------------------------
-- ��Ȩ����
----------------------------------
-- ������Ϊ�����������Ӱ��ɭ��Ȩ���С�
-- �����������ԭ��������η��������Ǳ���ͬ����Դ�������޸İ�Ȩ������
-- �����ص���Դ��Դ����֮����������֮����(lknovel.lightnovel.cn)��
-- ��Դ - ��֮���߰�Ȩ���С�
----------------------------------
-- Tips: �ù���ֻ��������Windows�£���֧�ֿ�ƽ̨��
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
	pgreen("> ��")
	io.write("        ��\t\t\t#\n")
	io.write("\t=================================================\n")
	local mouse="left"
	while true do
		local key=lcon.getch()
		if key==75 then
			lcon.gotoXY(25,3)
			pgreen("> ��")
			io.write("        ��")
			mouse="left"
		elseif key==77 or key==27 then
			lcon.gotoXY(25,3)
			io.write("  ��")
			lcon.gotoXY(35,3)
			pgreen("> ��")
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
	pgreen("> ȷ��\n")
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
	local res=selectbox("\t--- ��ӭʹ����֮������Դ������ ---\n\n\t\t=== �˵� ===\n\n",
		{"����һ��ϵ��",
		 "����һ��С˵",
		 "����һ���½�",
		 "��Ȩ��Ϣ",
		 "�˳�����"
		})
	if res==1 then
		while not id do
			cls()
			io.write("������ϵ�б�š�\n\t -- Tip:\n\t�������������򡷣���ϵ�е�ַΪ\n\t\thttp://lknovel.lightnovel.cn/main/vollist/83.html\n\t����ϵ�б��Ϊ83��ϵ�б��ֻ��Ϊ���֡�\n\n\t")
			id=tonumber(io.read())
		end
		db.flag=tfbox("[��Ҫ����ͼƬ��]")
		if db.flag then
			db.ppic=tfbox("[ͼƬҪ�ֱ�����]")
		end
		db.sta=res
		cls()
		return download(res,id)
	elseif res==2 then
		while not id do
			cls()
			io.write("������С˵��š�\n\t -- Tip:\n\t�������������򡤵�һ��������С˵��ַΪ\n\t\thttp://lknovel.lightnovel.cn/main/book/161.html\n\t����С˵���Ϊ161��С˵���ֻ��Ϊ���֡�\n\n\t")
			id=tonumber(io.read())
		end
		db.flag=tfbox("[��Ҫ����ͼƬ��]")
		db.sta=res
		cls()
		return download(res,id)
	elseif res==3 then
		while not id do
			cls()
			io.write("�������½ڱ�š�\n\t -- Tip:\n\t�������������򡤵�һ���������£����½ڵ�ַΪ\n\t\thttp://lknovel.lightnovel.cn/main/view/1062.html\n\t�����½ڱ��Ϊ1062���½ڱ��ֻ��Ϊ���֡�\n\n\t")
			id=tonumber(io.read())
		end
		db.flag=tfbox("[��Ҫ����ͼƬ��]")
		db.sta=res
		cls()
		return download(res,id)
	elseif res==4 then
		msgbox("\t\t       === ��Ȩ��Ϣ ===\n\t\t\t���� - Լ����_RK\n\t\t\t��Ʒ - ��Ӱ��� ({srkf.tk})\n\t\t\t��Դ - ��֮���� ({lknovel.lightnovel.cn})\n\n\t\t����: ������Ϊ��������������޸�Դ���벢�Ҷ��η�����\n\t\t      ����������İ�Ȩ��Ϣ(����Դ�����е�)��\n\t\t      ͬʱ���η���ʱ����ͬ����Դ��\n\n\t\t\t    ")
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
			io.write("���� - ϵ�в����ڡ�")
			os.execute("pause")
			return main()
		end
		db.path=togbk:iconv(res:match("<li class=\"active\">(.-)</li>")):gsub("[:%*\\/<>|%?\"]",""):match("^%s*(.-)%s*$")
		io.write("����ץȡϵ�С�",db.path,"��\n")
		os.execute("@mkdir \""..db.path.."\"")
		if not db.ppic and db.flag then
			os.execute("@mkdir \""..db.path.."\\pic\"")
		end
		for i in res:gmatch("<h2 class=\"ft%-24\">(.-)</h2>") do
			download(2,i:match("<a href=\"http://lknovel%.lightnovel%.cn/main/book/(%d+).html\">"))
		end
		io.write("ϵ�С�",db.path,"���������\n\n")
		os.execute("pause")
		return main()
	elseif id==2 then
		local res=get(id,key)
		if not res then
			io.write("���� - С˵�����ڡ�")
			os.execute("pause")
			return main()
		end
		db.unit=togbk:iconv(res:match("<title>.-%- (.-) %-").." - "..res:match("<li class=\"active\">(.-)</li>")):gsub("[:%*\\/<>|%?\"]",""):match("^%s*(.-)%s*$")
		io.write("����ץȡС˵��",db.unit,"��\n")
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
		io.write("С˵��",db.unit,"���������\n")
		if sta==2 then
			io.write("\n")
			os.execute("pause")
			return main()
		end
	elseif id==3 then
		local res=get(id,key)
		if res:find("<a href=\"/main/vollist/%.html\">") then
			io.write("���� - �½ڲ����ڡ�")
			os.execute("pause")
			return main()
		end
		local res=res:match("<div id=\"J_view\" class=\"mt%-20\">(.-)<div class=\"text%-center mt%-20\">")
		db.page=togbk:iconv(res:match("<h3 align=\"center\" class=\"ft%-20\">(.-)</h3>")):gsub("[:%*\\/<>|%?\"]",""):match("^%s*(.-)%s*$")
		io.write("���������½ڡ�",db.page,"��\n")
		local f=io.open(getpath(),"w")
		f:write(fmtext(res))
		f:close()
		if sta==2 then
			io.write("�½ڡ�"..db.page.."���������\n\n")
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
		io.write("������������������ӡ�")
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
			io.write("��ͼ",db.picid,"���������\n")
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
os.execute("title ��֮������Դ������")
lfs.mkdir("pic")
main()
