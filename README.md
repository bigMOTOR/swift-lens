# swift-lens
The concept of functional Lenses in Swift.

Functional Lens - convenient, powerful, and safe concept for data mutation.
A good [Talk about Lenses in Swift from Brandon Williams ](https://youtu.be/ofjehH9f-CU) highly recommended.

## Operators:
`*` - lenses composition;
`*~` - set value;
`|>` - piping.

Example of usage:
```swift
user = user |> User.idLens *~ newId
user = user |> (User.nameLens * Name.firstNameLens) *~ "Joel"
```

## SPM Install 
- Swift Package Manager by url: [https://github.com/bigMOTOR/swift-lens.git](https://github.com/bigMOTOR/swift-lens.git)

## Contributing

- Something wrong or you need anything else? Please open an issue or make a Pull Request.
- Pull requests are welcome.

## License

swift-lens is available under the MIT license. See the LICENSE file for more info.
