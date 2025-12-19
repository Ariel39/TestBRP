-- Returns the sequence name of the viewmodel
function easzy.bodydamage.GetViewModelAnimationName(ply)
    if not IsValid(ply) or not ply:IsPlayer() or not ply:Alive() then return end

    local viewModel = ply:GetViewModel()
    if not IsValid(viewModel) then return end

    local sequence = viewModel:GetSequence()
    local sequenceName = viewModel:GetSequenceName(sequence)

    return sequenceName
end

-- Plays an animation on the viewmodel by its name
function easzy.bodydamage.AnimViewModel(ply, name, rate)
    if not IsValid(ply) or not ply:IsPlayer() or not ply:Alive() then return end

    local viewModel = ply:GetViewModel()
    if not IsValid(viewModel) then return end

    local sequence, duration = viewModel:LookupSequence(name)
    if sequence == -1 or duration == 0 then return end

    -- In order not to restart the sequence
    if viewModel:GetSequence() == sequence and viewModel:GetPlaybackRate() == rate then return end

    viewModel:SendViewModelMatchingSequence(sequence)
    viewModel:SetPlaybackRate(rate or 1)

    return math.abs(duration/rate)
end

-- Plays multiple animations on the viewmodel and calls a callback at the end of each animation
function easzy.bodydamage.AnimViewModelSequence(ply, animationsList, time)
    if not IsValid(ply) or not ply:IsPlayer() or not ply:Alive() then return end

    local viewModel = ply:GetViewModel()
    if not IsValid(viewModel) then return end

    -- Used to stop the previous sequence when a new one is started
    local time = time or CurTime()
    viewModel:SetVar("ezbodydamage_lastAnimationsSequence", time)

    local animation = animationsList[1]
    if not animation then return end

    local duration = easzy.bodydamage.AnimViewModel(ply, animation.name, animation.rate)
    if not duration then duration = 0 end

    local delay = duration + (animation.delay or 0)

    timer.Simple(delay, function()
        if not IsValid(ply) or not ply:IsPlayer() or not ply:Alive() then return end

        local lastAnimationsSequence = viewModel:GetVar("ezbodydamage_lastAnimationsSequence") or 0
        if #animationsList == 0 or lastAnimationsSequence > time then
            return
        end

        if animation.callback then
            local result = animation.callback(ply)
            if result == -1 then return end
        end
        table.remove(animationsList, 1)

        easzy.bodydamage.AnimViewModelSequence(ply, animationsList, time)
    end)
end
