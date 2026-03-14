WeaponNames = {
    ['WEAPON_PICKAXE']       = 'Pickaxe',
    ['WEAPON_COPPERPICKAXE'] = 'Copper Pickaxe',
    ['WEAPON_SILVERPICKAXE'] = 'Silver Pickaxe',
    ['WEAPON_GOLDPICKAXE']   = 'Gold Pickaxe',
}

function GetWeaponDisplayName(weaponName)
    if not weaponName then return 'Unknown' end
    return WeaponNames[string.upper(weaponName)] or weaponName
end