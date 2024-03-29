

class UserProfile{

  String name;
  List<UserImage> userImage;
  String introduction;
  String phone;
  UserProfile( this.name, this.introduction,this.phone, this.userImage);
}

class UserProfileModel {
  List<UserProfile> userProfile = [
    UserProfile("Hung", "Sinh năm 1990", "0943418618",[
      UserImage('https://picsum.photos/250?image=9', ImagePath.network),
      // UserImage(
      //     'https://img-s-msn-com.akamaized.net/tenant/amp/entityid/AA14IbN8.img?w=640&h=427&m=6&x=298&y=176&s=67&d=67',
      //     ImagePath.network),
      UserImage('https://uni.fpt.edu.vn/Data/Sites/1/Banner/b%E1%BA%A3n-ta.jpg',
          ImagePath.network),
      UserImage('https://picsum.photos/250?image=9', ImagePath.network),
      UserImage('https://picsum.photos/250?image=9', ImagePath.network),
      UserImage('https://picsum.photos/250?image=9', ImagePath.network),
      UserImage('https://picsum.photos/250?image=9', ImagePath.network),
    ]),
    UserProfile("Binh", "Sinh năm 2000","0943118618", [
      UserImage('https://img-s-msn-com.akamaized.net/tenant/amp/entityid/AA14IbN8.img?w=640&h=427&m=6&x=298&y=176&s=67&d=67', ImagePath.network),
      UserImage('https://th.bing.com/th?id=OIP.LGYUipwp2Q1PCN0FdcQCVgHaEo&w=316&h=197&c=8&rs=1&qlt=90&o=6&dpr=1.3&pid=3.1&rm=2',
          ImagePath.network),
      UserImage('https://picsum.photos/250?image=9', ImagePath.network),
      UserImage('https://scontent.fhan17-1.fna.fbcdn.net/v/t1.6435-9/42260186_2104152083169870_6281917530470612992_n.jpg?_nc_cat=100&ccb=1-7&_nc_sid=09cbfe&_nc_ohc=NxNEvZteHfEAX8V9ypJ&_nc_ht=scontent.fhan17-1.fna&oh=00_AfBrrhVaqKEBSt8ISodyuCOBp-S-PioWpr0kx-NJcLP_VA&oe=64B23CBA', ImagePath.network),
      UserImage('https://picsum.photos/250?image=9', ImagePath.network),


      UserImage('https://th.bing.com/th?id=OIP.sj_5aI6euLhoH7_17uRZOAHaEK&w=333&h=187&c=8&rs=1&qlt=90&o=6&dpr=1.3&pid=3.1&rm=2', ImagePath.network),
    ]),
    UserProfile("Long", "Sinh năm 2009", "0913418618",[
      UserImage('http://tpl.gco.vn/tamlygiaoduc/images/detail__1.jpg', ImagePath.network),
      UserImage('https://picsum.photos/250?image=9', ImagePath.network),
      UserImage('https://picsum.photos/250?image=9', ImagePath.network),
      UserImage('https://picsum.photos/250?image=9', ImagePath.network),
      UserImage('https://picsum.photos/250?image=9', ImagePath.network),
      UserImage('https://picsum.photos/250?image=9', ImagePath.network),
    ]),
    UserProfile("Minh", "Sinh năm 2008","0923418618", [
      UserImage('https://khoacntt.naem.edu.vn/uploads/images/banner__1.jpg', ImagePath.network),
      UserImage('https://picsum.photos/250?image=9', ImagePath.network),
      UserImage('https://picsum.photos/250?image=9', ImagePath.network),
      UserImage('https://picsum.photos/250?image=9', ImagePath.network),
      UserImage('https://picsum.photos/250?image=9', ImagePath.network),
      UserImage('https://picsum.photos/250?image=9', ImagePath.network),
    ]),
    UserProfile("Van", "Sinh năm 2006","0963418618", [
      UserImage('http://tpl.gco.vn/tamlygiaoduc/images/detail__1.jpg', ImagePath.network),
      UserImage('https://picsum.photos/250?image=9', ImagePath.network),
      UserImage('https://picsum.photos/250?image=9', ImagePath.network),
      UserImage('https://picsum.photos/250?image=9', ImagePath.network),
      UserImage('https://picsum.photos/250?image=9', ImagePath.network),
      UserImage('https://picsum.photos/250?image=9', ImagePath.network),
    ])
  ];
}

class UserImage{
  String uRL;
  ImagePath source;
  UserImage(this.uRL, this.source);
}
enum ImagePath {asset, gallery, camera, network}