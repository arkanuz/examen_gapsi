//
//  ConnectionManager.swift
//  examen_gapsi
//
//  Created by Adolfo Lozada Serena on 24/04/21.
//

import Foundation

// Clase de respuesta donde se manda la respuesta del servidor
// si 'code'= 0, la respuesta fue satisfactoria,
// cualquier'code' != 0 es un fallo y se manda mensaje del error
class Response : NSObject {
    var code: Int = 0
    var message: String = ""
    var object: (Any)? = nil
}



public class ConnectionManager: NSObject {

    // Busca en el servicio lo que el usuario indica y retorna un 'Response'
    // y en la propiedad 'object' retorna un '[Result]'
    func connectionSearchResults(_ search: String, block completionBlock: @escaping (Response) -> Void){
        if let url = URL(string: "https://00672285.us-south.apigw.appdomain.cloud/demo-gapsi/search?&query=\(search)") {
            var urlRequest = URLRequest.init(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 20)
            // Configuración del request
            urlRequest.httpMethod = "GET"
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let configuration = URLSessionConfiguration.default
            configuration.requestCachePolicy = .useProtocolCachePolicy
            
            // Establecer credenciales de acceso
            let key = "X-IBM-Client-Id"
            let value = "adb8204d-d574-4394-8c1a-53226a40876e"
            urlRequest.addValue(value, forHTTPHeaderField: key)
            
            // Establecer conección
            let session = URLSession.init(configuration: configuration)
            let dataTask = session.dataTask(with: urlRequest){
                (data, response, error) in
                guard let data = data, let urlResponse = response as? HTTPURLResponse, error == nil else {
                    DispatchQueue.main.async {
                        let response = Response()
                        response.code = -1
                        response.message = "Sin Conexión"
                        response.object = nil
                        completionBlock(response)
                    }
                    return
                }
                // Conección exitosa
                if urlResponse.statusCode == 200 {
                    if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary {
                        DispatchQueue.main.async {
                            let response = Response()
                            response.code = 0
                            response.message = "Ok"
                            
                            // Guardar el resultado
                            var items = [Items]()
                            for dict in json.object(forKey: "items") as! [NSDictionary]{
                                let item = Items(
                                    itemId: dict.object(forKey: "id") as? Int,
                                    rating: dict.object(forKey: "rating") as! String,
                                    price: dict.object(forKey: "price") as! String,
                                    image: dict.object(forKey: "image") as! String,
                                    title: dict.object(forKey: "title") as! String)
                                items.append(item)
                            }
                            
                            let result = Result(
                                totalResults: json.object(forKey: "totalResults") as? Int,
                                page: json.object(forKey: "page") as? Int,
                                items: items)
                            
                            response.object = result
                            completionBlock(response)
                        }
                    }
                }
                // Error en conección
                else {
                    DispatchQueue.main.async {
                        let response = Response()
                        response.code = urlResponse.statusCode
                        response.message = "Error \(urlResponse.statusCode)"
                        response.object = nil
                        completionBlock(response)
                    }
                }
            }
            dataTask.resume()
        }
        
    }
}
