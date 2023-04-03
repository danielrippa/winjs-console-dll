# WinjsConsole.dll

```

  get-js-value: ->

    window:

      get-title: -> string
      set-title: (title: string) -> void

      get-full-screen: -> boolean
      set-full-screen: (full-screen: boolean) -> void

      get-input-code-page: -> number
      set-input-code-page: (code-page: number) -> void

      get-output-code-page: -> number
      set-output-code-page: (code-page: number) -> void

      get-quick-edit-state: -> boolean
      set-quick-edit-state: (quick-edit-state: boolean) -> void

    input:

      is-quick-edit-mode-enabled: (handle: number) -> boolean
      set-quick-edit-mode: (handle: number, mode: boolean) -> void

      get-input-event-type: (handle: number) -> string
      discard-input-event: -> void

      get-window-focus-event: -> 

        void | 
        
          focused: boolean

      get-window-resize-event: ->

        void | 

          rows: number
          columns: number

      get-key-pressed-event: ->

        void |

          scan-code: number
          key-code: number
          key-type: string
          repetitions: number

      get-key-released-event: ->

        void |

          scan-code: number
          key-code: number

      get-mouse-moved-event: ->

        void |

          row: number
          column: number

      get-single-click-event: ->

        void |

          row: number
          column: number

          left1: boolean
          left2: boolean
          left3: boolean
          left4: boolean

          right-most: boolean

      get-double-click-event: ->

        void |

          row: number
          column: number

          left1: boolean
          left2: boolean
          left3: boolean
          left4: boolean

          right-most: boolean

      get-click-release-event: ->

        void |

          row: number
          column: number

      get-vertical-wheel-event: ->

        void |

          row: number
          column: number

          direction: string

      get-horizontal-wheel-event: ->

        void |

          row: number
          column: number

          direction: string

    screen-buffer:

      new-screen-buffer-handle: number
      activate-screen-buffer: (handle: number) -> void
      close-screen-buffer: (handle: number) -> void

      get-size: (handle: number) -> 
        
        height: number
        width: number
  
      set-size: (handle: number, height: number, width: number)  -> void
  
      get-stdout-handle: -> number

      get-cursor-location: (handle: number) -> 

        row: number
        column: number

      set-cursor-location: (handle: number, row: number, column: number) -> void

      get-cursor-visibility: (handle: number) -> boolean
      set-cursor-visibility: (handle: number, visibility: boolean) -> void

      get-cursor-size: (handle: number) -> number
      set-cursor-size: (handle: number, size: number) -> void

      is-virtual-terminal-processing-enabled: (handle: number) -> boolean
      set-virtual-termina-processing-state: (handle: number, state: boolean) -> void
      
      is-new-line-auto-return-enabled: (handle: number) -> boolean
      set-new-line-auto-return-state: (handle: number, state: boolean) -> void
      
      is-processed-output-enabled: (handle: number) -> boolean
      set-processed-output-state: (handle: number, state: boolean) -> void
      
      is-wrap-at-eol-enabled: (handle: number) -> boolean
      set-wrap-at-eol-state: (handle: number, state: boolean) -> void

      are-extended-attributes-enabled: (handle: number) -> boolean
      set-extended-attributes-state: (handle: number, state: boolean) -> void

      get-text-attributes-value: (handle) -> number
      set-text-attributes-value: (handle: number, value: number) -> void

      get-palette-color: (handle: number, color-index: number) -> number
      set-palette-color: (handle: number, color-index: number, r: number, g: number, b: number)-> void

      get-font-face: (handle: number) -> string
      set-font-face: (handle: number, font-face: string) -> void
      
      get-font-weight: (handle: number) -> number
      set-font-weight: (handle: number, font-weight: number) -> void

      get-font-height: (handle: number) -> number
      set-font-height: (handle: number, font-height: number) -> void

      get-font-width: (handle: number) -> number
      set-font-width: (handle: number, font-width: number) ->

      get-area-attributes: (handle: number, top: number, left: number, height: number, width: number) -> [ number ]
      set-area-attributes: (handle: number, top: number, left: number, height: number, width: number, attributes: [ number ]) -> void

      get-area-characters: (handle: number, top: number, left: number, height: number, width: number)-> string
      set-area-characters: (handle: number, top: number, left: number, height: number, width: number, characters: string) -> void

      set-area-attributes-value: (handle: number, top: number, left: number, height: number, width: number, attribute-value: number, length: number) -> void
      set-area-character: (handle: number, top: number, left: number, height: number, width: number, character: string, length: number) -> void
      
      scroll-area: (handle: number,  top: number, left: number, height: number, width: number, location-row: number, location-column: number, fill-character: string, fill-text-attributes: number) -> void

      write: (handle: number, value: string) -> void

    get-font-faces: -> [ string ]

```
