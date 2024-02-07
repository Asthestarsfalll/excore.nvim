An extention of [ExCore](https://github.com/Asthestarsfalll/ExCore), used for simple code navigation from config file to code definition.

## Screen Shot
![to_class]("./assets/to_class.gif")

## Usage

```lua
{
    "Asthestarsfalll/excore.nvim",
    event = "VeryLazy",
    config = function()
        require("excore").setup {
            cache_dir = nil,
        }
    end
}
```

## User Commands

`ExLoad`: Load the cached `class_mapping.json`, need to run in a excore project.
`ExDir`: Manualy setting the cache-dir if ExLoad cannot work. Then run `ExLoad` again.
`ToClass`: Jump the the class definition according to the identifier under the cursor. You can manualy bind it to some shortcut keys.
