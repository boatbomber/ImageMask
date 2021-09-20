------------------------------------------------------------------------------
-- Image Clipping Module
-- by boatbomber
--
-- For a detailed write-up, see here:
-- https://devforum.roblox.com/t/open-source-image-clipping-module/293014
--
-- API Overview:
--
-- module.new(<string> ID, <string> Type)
--  returns ViewportFrame,ClipperPart
--
------------------------------------------------------------------------------

--Services
local Marketplace = game:GetService("MarketplaceService")
local Http = game:GetService("HttpService")

--Prefabricate objects
local Camera = Instance.new("Camera")
	Camera.FieldOfView	= 20

local ViewportFrame	= Instance.new("ViewportFrame")
	ViewportFrame.BackgroundColor3 = Color3.new()
	ViewportFrame.BackgroundTransparency = 1
	ViewportFrame.LightDirection = Vector3.new(0,1,0)
	ViewportFrame.Ambient = Color3.new(1,1,1)
	ViewportFrame.Size = UDim2.new(0,100,0,100)

local Decal = Instance.new("Decal")
	Decal.Face = Enum.NormalId.Top
	
--Setup static variables
local v3,cf		= Vector3.new,CFrame.new
local match,max	= string.match,math.max
local clipperSize, clipperCF = v3(1,0.1,1), cf(0,-0.1,0)


local module = {}

function module.new(ID, Type)
	
	--Sanity checks
	assert(ID and type(ID) == "string" and match(ID,"%d+"), "Invalid Image ID: "..ID)
	assert(Type and type(Type) == "string" and script:FindFirstChild(Type), "Invalid Clipper Type: "..Type)
	
	--Clipper mesh
	local Clipper = script:FindFirstChild(Type):Clone()
		Clipper.Size = clipperSize
		Clipper.CFrame = clipperCF
		Clipper.Transparency = 1
		
	--Decal Image
	local Image = Decal:Clone()
		Image.Texture = ID
		
	--Camera renderpoint
	local Cam = Camera:Clone()
		Cam.CFrame = CFrame.new(Vector3.new(0,(max(Clipper.Size.X,Clipper.Size.Z)/2)/0.17,0),Vector3.new())*CFrame.Angles(0,0,-1.5707963267949)
		
	--ViewportFrame
	local Frame = ViewportFrame:Clone()
		Frame.CurrentCamera = Cam

	--Finalize setup
	Image.Parent = Clipper
	Clipper.Parent = Frame
	Cam.Parent = Frame	--If Frame is deleted, so is Cam (avoiding mem leaks)
	
	return Frame, Clipper
end

return module
