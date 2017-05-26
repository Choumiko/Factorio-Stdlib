Train_Spec_Fixtures = {
    Single_Train_With_Single_Locomotive = {
        [1] = {
            name = 'diesel-locomotive',
            type = 'locomotive',
            unit_number = 1000,
            train = {
                id = 1001,
                valid = true,
                state = 1,
                locomotives = {
                    front_movers = {
                        [1] = { unit_number = 1000 }
                    },
                    back_movers = nil
                },
                carriages = {
                  [1] = { unit_number = 1000 }
                }
            }
        }
    },

    Single_Train_With_Two_Locomotives = function()
        local train = {
            id = 1001,
            valid = true,
            state = 1,
            locomotives = {
                front_movers = {
                    [1] = { unit_number = 1000 }
                },
                back_movers = {
                    [1] = { unit_number = 2000 }
                }
            }
        }

        local loco_1 = {
            name = 'diesel-locomotive',
            type = 'locomotive',
            unit_number = 1000,
            train = train
        }

        local loco_2 = {
            name = 'diesel-locomotive',
            type = 'locomotive',
            unit_number = 2000,
            train = train
        }

        return {
            [1] = loco_1,
            [2] = loco_2
        }
    end,

    Two_Trains_With_Single_Locomotive = {
        [1] = {
            name = 'diesel-locomotive',
            type = 'locomotive',
            unit_number = 1000,
            train = {
                id = 1001,
                valid = true,
                state = 1,
                locomotives = {
                    front_movers = {
                        [1] = { unit_number = 1000 }
                    },
                    back_movers = nil
                }
            }
        },

        [2] = {
            name = 'diesel-locomotive',
            type = 'locomotive',
            unit_number = 2000,
            train = {
                id = 2001,
                valid = true,
                state = 1,
                locomotives = {
                    front_movers = {
                        [1] = { unit_number = 2000 }
                    },
                    back_movers = nil
                }
            }
        }
    },

    Trains_In_Different_States = {
        [1] = {
            name = 'diesel-locomotive',
            type = 'locomotive',
            unit_number = 1000,
            train = {
                id = 1001,
                valid = true,
                state = 1,
                locomotives = {
                    front_movers = {
                        [1] = { unit_number = 1000 }
                    },
                    back_movers = nil
                }
            }
        },

        [2] = {
            name = 'diesel-locomotive',
            type = 'locomotive',
            unit_number = 2000,
            train = {
                id = 2001,
                valid = true,
                state = 9,
                locomotives = {
                    front_movers = {
                        [1] = { unit_number = 2000 }
                    },
                    back_movers = nil
                }
            }
        }
    },

    Train_With_Front_And_Back_Locomotives_A = function()
        train = {
            id = 1001,
            valid = true,
            state = 1,
            locomotives = {
                front_movers = {
                    [1] = { unit_number = 1000 }
                },
                back_movers = {
                    [1] = { unit_number = 2000 }
                }
            }
        }

        loco_1 = {
            name = 'diesel-locomotive',
            type = 'locomotive',
            unit_number = 1000,
            train = train
        }

        loco_2 = {
            name = 'diesel-locomotive',
            type = 'locomotive',
            unit_number = 2000,
            train = train
        }

        return {
            [1] = loco_1,
            [2] = loco_2
        }
    end,

    Train_With_Front_And_Back_Locomotives_B = function()
        train = {
            id = 2001,
            valid = true,
            state = 1,
            locomotives = {
                front_movers = {
                    [1] = { unit_number = 2000 }
                },
                back_movers = {
                    [1] = { unit_number = 1000 }
                }
            }
        }

        loco_1 = {
            name = 'diesel-locomotive',
            type = 'locomotive',
            unit_number = 1000,
            train = train
        }

        loco_2 = {
            name = 'diesel-locomotive',
            type = 'locomotive',
            unit_number = 2000,
            train = train
        }

        return {
            [1] = loco_1,
            [2] = loco_2
        }
    end,
}
