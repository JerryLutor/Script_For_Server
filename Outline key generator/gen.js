const generateAccesskey = (method, password, ip, port) => {
    const firstPart = btoa(`${method.toLowerCase()}:${password}`)
   const secondPart = `${ip}:${port}`
   const accesskey = `ss://${firstPart}@${secondPart}`
   return accesskey
}
