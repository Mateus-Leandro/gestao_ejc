# Gestão EJC

Projeto para gerenciar o Encontro de Jovens com Cristo (EJC).

## Requisitos do Projeto

### IDE
- [Visual Studio Code](https://code.visualstudio.com/download) ou [Android Studio](https://developer.android.com/studio?gad_source=1&gclid=CjwKCAiAudG5BhAREiwAWMlSjO6FBrpbh6G84Q4o_L2cCrlLirhFwznseAT1G0xjWlLesvIeyTt-QBoC8zsQAvD_BwE&gclsrc=aw.ds&hl=pt-br)

### Flutter SDK
1. Instale o SDK do Flutter:
   - **Observação:** Após escolher o sistema operacional, selecione a opção "Web" durante a instalação.
   - [Guia de Instalação do Flutter](https://docs.flutter.dev/get-started/install)

### Integração com Firebase
1. Instale a CLI do Firebase:
   - [Firebase CLI](https://firebase.google.com/docs/cli?hl=pt-br#setup_update_cli)

2. Abra o terminal na pasta raiz do projeto e faça login com o comando:
   - **Observação:** Utilize o mesmo e-mail que está vinculado ao projeto no Firebase.
```bash 
   firebase login
``` 
## Baixar dependências e executar projeto:
1. Abra o terminal na pasta raiz do projeto de utlize os seguintes comandos:
```bash
  flutter pub get 
  flutter run
```
- **Observação:** Necessário navegador Chrome ou Edge.

## Links de acesso
[Produção](https://gestao-ejc.web.app)  
[Developer](https://gestao-ejc--dev-ts4eyipw.web.app)  
[Firebase](https://console.firebase.google.com/u/0/project/gestao-ejc/firestore/databases/-default-/data/~2Fencounter~2FI)
- **Observação:** Apesar de links separados, o banco do firebase é o mesmo para ambos ambientes(Dev/produção).

## CI/CD
[Deploy link DEV](.github/workflows/dev_deploy_on_push.yml)  
[Deploy link Produção](.github/workflows/master_deploy_on_push.yml) 
 - **Observação:** Scripts realizam o build do projeto e posteriormente o deploy do site(dev ou produção) de acordo com a branch que recebeu o git push. 
 - Caso queira realizar um deploy sem push (somente para teste e apenas no link de dev), utilize os seguintes comandos na pasta raiz do projeto: 
```bash
   flutter build web 
   firebase hosting:channel:deploy dev --expires 30d
```