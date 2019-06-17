local SceneController = {}

function SceneController:Init(  )
	print('Cat:SceneController.lua[Init]')
    self.sceneNode = GameObject.Find("UICanvas/Scene")
	self.mainCamera = Camera.main
	self:InitEvents()

end

function SceneController:InitEvents(  )
	local on_start_game = function (  )
		print('Cat:SceneController.lua[13]')
		ECS:Init(SceneMgr.Instance.EntityManager)
	end
    GlobalEventSystem:Bind(GlobalEvents.GameStart, on_start_game)

    local on_down = function ( target, x, y )
    	print('Cat:SceneController.lua[down] x, y', target, x, y)
    	self.touch_begin_x = x
    	self.touch_begin_y = y
    end
	UIHelper.BindClickEvent(self.sceneNode, on_down)

	local on_up = function ( target, x, y )
    	-- print('Cat:SceneController.lua[up] x, y', target, x, y)
        local hit = SceneHelper.GetClickSceneObject()
        if hit then
            print('Cat:SceneController.lua[35] hit.entity, hit.point.x, hit.point.y', hit.entity, hit.point.x, hit.point.y)
            print('Cat:SceneController.lua[30] ECS:HasComponent(hit.entity, CS.UnityMMO.Component.SceneObjectTypeData)', ECS:HasComponent(hit.entity, CS.UnityMMO.Component.SceneObjectTypeData))
            if hit.entity == Entity.Null then
                local goe = RoleMgr.GetInstance():GetMainRole()
                local moveQuery = goe:GetComponent(typeof(CS.UnityMMO.MoveQuery))
                print('Cat:SceneController.lua[39] moveQuery', moveQuery)
                local findInfo = {
                    destination = hit.point,
                    stoppingDistance = 2,
                }
                moveQuery:StartFindWay(findInfo)
            elseif ECS:HasComponent(hit.entity, CS.UnityMMO.Component.SceneObjectTypeData) then
                local sceneObjType = ECS:GetComponentData(hit.entity, CS.UnityMMO.Component.SceneObjectTypeData)
                print('Cat:SceneController.lua[41] sceneObjType', sceneObjType.Value)
            end
        end
    end
	UIHelper.BindClickEvent(self.sceneNode, on_up)

end

return SceneController