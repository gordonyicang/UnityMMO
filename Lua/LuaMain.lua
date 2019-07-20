require "Game.Common.UIManager"
PrefabPool = require "Game.Common.PrefabPool"
require "Common.UI.UIComponent"
require("Common.UI.ItemListCreator")
require("Game.Common.Message")

--管理器--
local Game = {}
local Ctrls = {}

function LuaMain()
    print("logic start")     
    UpdateManager:GetInstance():Startup()
    Game:OnInitOK()
end

--初始化完成
function Game:OnInitOK()
    print('Cat:Game.lua[Game.OnInitOK()]')
    Game:InitLuaPool()
    Game:InitUI()
    Game:InitControllers()
end

function Game.InitUI()
    local msg_panel = GameObject.Find("UICanvas/Dynamic/MessagePanel")
    assert(msg_panel, "cannot fine message panel!")
    Message:Init(msg_panel.transform)

    UIMgr:Init({"UICanvas/Normal","UICanvas/MainUI", "UICanvas/Dynamic"}, "Normal")
    
    local pre_load_prefab = {
        "Assets/AssetBundleRes/ui/common/Background.prefab",
        "Assets/AssetBundleRes/ui/common/GoodsItem.prefab",
        "Assets/AssetBundleRes/ui/common/WindowBig.prefab",
    }
    PrefabPool:Init("UICanvas/HideUI")
    PrefabPool:Register(pre_load_prefab)
end

function Game:InitControllers()
    local ctrl_paths = {
        "Game/Test/TestController",
        "Game/Login/LoginController", 
        "Game/MainUI/MainUIController", 
        "Game/Task/TaskController", 
        "Game/Scene/SceneController", 
        "Game/Bag/BagController", 
        "Game/GM/GMController", 
    }
    for i,v in ipairs(ctrl_paths) do
        local ctrl = require(v)
        if type(ctrl) ~= "boolean" then
            --调用每个Controller的Init函数
            ctrl:Init()
            table.insert(Ctrls, ctrl)
        else
            --Controller类忘记了在最后return
            assert(false, 'Cat:Main.lua error : you must forgot write a return in you controller file :'..v)
        end
    end
end

function Game:InitLuaPool(  )
    LuaPool = require "Game.Common.LuaPool"
    local info = {
        ["Pool-Window"] = {
            name="Pool-Window", maxNum=5, prototype = require("Game.Common.UI.Window")
        },
        ["Pool-TabBar"] = {
            name="Pool-TabBar", maxNum=5, createFunc=function()
                return require("Game.Common.UI.TabBar").New()
            end
        },
    }
    LuaPool:Init(info)
end

--销毁--
function Game:OnDestroy()
end
