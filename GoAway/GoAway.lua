local t = {
  "MicroButtonAndBagsBar",
  "StatusTrackingBarManager",
}

local function showFoo(self)
  for _, v in ipairs(t) do
    _G[v]:SetAlpha(1)
  end
end

local function hideFoo(self)
  for _, v in ipairs(t) do
    _G[v]:SetAlpha(0)
  end
end

for _, v in ipairs(t) do
  v = _G[v]
  v:SetScript("OnEnter", showFoo)
  v:SetScript("OnLeave", hideFoo)
  v:SetAlpha(0)
end
