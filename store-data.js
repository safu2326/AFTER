(function(){
  const KEY='afterStoreConfigV2';
  const legacy='afterStoreConfigV1';
  const defaults={
    brand:'AFTER',
    announcement:'FREE DELIVERY ON ORDERS OVER ৳2,000  •  NEW DROP EVERY WEEK',
    accent:'#b9824c',
    deliveryCharge:0,
    logoImage:'',
    heroEyebrow:'THE AFTER EDIT / 01',
    heroTitle:'Technology,\ncurated beautifully.',
    heroText:'A refined collection of everyday gadgets, smart accessories and useful tech — selected to make modern living feel effortless.',
    heroButton:'EXPLORE THE COLLECTION',
    heroImage:'assets/hero-visual.jpg',
    heroBadge:'NEW SEASON',
    sectionCategories:'Shop by mood',
    sectionFeatured:'Best sellers',
    sectionNew:'Fresh arrivals',
    sectionStory:'The AFTER edit',
    storyTitle:'Less noise.\nBetter technology.',
    storyText:'We choose products for the way they look, feel and work in real life. Nothing random. Just useful technology with a little more character.',
    about:{
      eyebrow:'THE STORY BEHIND AFTER',
      title:'Technology, with a little more soul.',
      intro:'AFTER is a curated space for the objects that quietly make modern life better — useful, beautiful, and just unexpected enough.',
      storyTitle:'We are here for the in-between.',
      storyText:'Between function and feeling. Between the thing you need and the thing you did not know you wanted. AFTER exists to make that space more interesting, with technology chosen for real life rather than endless noise.',
      manifesto:'Less clutter. More character. Better things.',
      contactTitle:'Let’s talk.',
      contactText:'Have a question, a collaboration idea, or simply want to say hello? Our inbox is open.',
      email:'safu2326@gmail.com',
      visual:'assets/about-character.svg',
      visualLabel:'AFTER / CHARACTER 01',
      statOne:'01', statOneLabel:'CURATED MINDSET',
      statTwo:'24/7', statTwoLabel:'IDEAS IN MOTION',
      statThree:'∞', statThreeLabel:'ROOM FOR WHAT’S NEXT'
    },
    blogPosts:[
      {id:'b1',eyebrow:'GUIDE / 01',title:'How to build a calmer tech setup',text:'Small choices can make everyday technology feel better.',image:'assets/products/05-keyboard.svg'},
      {id:'b2',eyebrow:'FIELD NOTES / 02',title:'The objects we keep close',text:'A closer look at useful things with good design.',image:'assets/products/03-watch.svg'},
      {id:'b3',eyebrow:'AFTER HOURS / 03',title:'Buying less, choosing better',text:'Why thoughtful selection beats endless scrolling.',image:'assets/products/06-powerbank.svg'}
    ],
    trustTitle:'Why shop AFTER',
    trustItems:[
      {title:'Thoughtfully selected',text:'Products chosen for everyday use.'},
      {title:'Fast & secure delivery',text:'Simple checkout and careful packing.'},
      {title:'Human support',text:'We’re here when you need us.'}
    ],
    pages:{
      categories:{eyebrow:'FIND YOUR EVERYDAY ESSENTIAL.',title:'Categories',text:'Explore the things that make everyday life a little better.'},
      blog:{eyebrow:'IDEAS FOR A MORE CONNECTED LIFE.',title:'The AFTER Journal',text:'Stories, guides and inspiration for smarter everyday living.'},
      about:{eyebrow:'SMART DEVICES / BETTER LIVING.',title:'A little about AFTER',text:'We believe thoughtful technology should make everyday life feel simpler, more useful and more beautiful.'},
      search:{eyebrow:'FIND WHAT YOU ARE LOOKING FOR.',title:'Search',text:'Search the AFTER collection by product name, category or keyword.'},
      cart:{eyebrow:'A LITTLE ROOM FOR SOMETHING USEFUL.',title:'Your bag',text:'Review your selected products and continue when you’re ready.'},
      account:{eyebrow:'WELCOME TO AFTER.',title:'Your account',text:'Sign in to continue shopping or access your AFTER account.'}
    },
    products:[
      {id:'p1',name:'AirPods Pro',category:'Audio',price:'৳24,900',oldPrice:'',tag:'BEST SELLER',image:'assets/products/01-audio.svg',description:'Immersive sound with adaptive noise control.',featured:true,new:false,rating:'4.9',reviews:'128',features:['Adaptive noise control','Immersive spatial audio','All-day listening comfort']},
      {id:'p2',name:'Studio Headphones',category:'Audio',price:'৳8,490',oldPrice:'৳9,990',tag:'-15%',image:'assets/products/02-headphones.svg',description:'Deep sound, soft fit, all-day comfort.',featured:true,new:false,rating:'4.8',reviews:'96',features:['Rich detailed sound','Soft memory-foam cushions','Long battery life']},
      {id:'p3',name:'Smart Watch S',category:'Wearables',price:'৳6,990',oldPrice:'',tag:'NEW',image:'assets/products/03-watch.svg',description:'A clean daily companion for movement and time.',featured:true,new:true,rating:'4.7',reviews:'64',features:['Health & activity tracking','Bright always-on display','Smart notifications']},
      {id:'p4',name:'Pocket Camera',category:'Cameras',price:'৳14,500',oldPrice:'',tag:'TRENDING',image:'assets/products/04-camera.svg',description:'Small camera. Big personality.',featured:true,new:true,rating:'4.8',reviews:'51',features:['High-quality compact sensor','Pocket-friendly body','Fast autofocus']},
      {id:'p5',name:'Wireless Keyboard',category:'Desk Setup',price:'৳4,290',oldPrice:'',tag:'',image:'assets/products/05-keyboard.svg',description:'Minimal keys for a calmer desk.',featured:false,new:true,rating:'4.6',reviews:'39',features:['Low-profile keys','Wireless connection','Minimal desk footprint']},
      {id:'p6',name:'MagSafe Power Bank',category:'Mobile Tech',price:'৳3,490',oldPrice:'',tag:'NEW',image:'assets/products/06-powerbank.svg',description:'Pocket-sized power for everyday carry.',featured:false,new:true,rating:'4.7',reviews:'44',features:['Magnetic wireless charging','Compact everyday carry','USB-C fast charging']},
      {id:'p7',name:'Smart Desk Lamp',category:'Smart Home',price:'৳3,990',oldPrice:'',tag:'',image:'assets/products/07-lamp.svg',description:'Warm light with a smarter touch.',featured:false,new:false,rating:'4.6',reviews:'32',features:['Adjustable warm light','Touch controls','Clean modern silhouette']},
      {id:'p8',name:'Phone Stand Pro',category:'Mobile Tech',price:'৳1,290',oldPrice:'',tag:'',image:'assets/products/08-stand.svg',description:'A simple stand that belongs on every desk.',featured:false,new:false,rating:'4.5',reviews:'27',features:['Stable weighted base','Adjustable viewing angle','Desk-friendly design']}
    ],
    categories:[
      {id:'audio',name:'Audio',count:'08 items',image:'assets/products/02-headphones.svg'},
      {id:'wearables',name:'Wearables',count:'06 items',image:'assets/products/03-watch.svg'},
      {id:'mobile',name:'Mobile Tech',count:'12 items',image:'assets/products/06-powerbank.svg'},
      {id:'desk',name:'Desk Setup',count:'09 items',image:'assets/products/05-keyboard.svg'},
      {id:'smart-home',name:'Smart Home',count:'07 items',image:'assets/products/07-lamp.svg'}
    ]
  };
  function clone(x){return JSON.parse(JSON.stringify(x));}
  window.AFTER_DEFAULT_STORE=defaults;
  window.AFTER_STORE_KEY=KEY;
  window.getAfterStore=function(){
    try{
      let saved=JSON.parse(localStorage.getItem(KEY)||'null');
      if(!saved){
        const old=JSON.parse(localStorage.getItem(legacy)||'null');
        if(old) saved=old;
      }
      if(!saved) return clone(defaults);
      const merged=Object.assign(clone(defaults),saved);
      merged.categories=saved.categories||clone(defaults.categories);
      merged.products=saved.products||clone(defaults.products);
      merged.pages=Object.assign(clone(defaults.pages),saved.pages||{});
      merged.about=Object.assign(clone(defaults.about),saved.about||{});
      merged.trustItems=saved.trustItems||clone(defaults.trustItems);
      merged.deliveryCharge=Number.isFinite(Number(saved.deliveryCharge))?Number(saved.deliveryCharge):Number(defaults.deliveryCharge||0);
      merged.blogPosts=saved.blogPosts||clone(defaults.blogPosts);
      merged.orders=saved.orders||[];
      return merged;
    }catch(e){return clone(defaults)}
  };
  window.saveAfterStore=function(data){localStorage.setItem(KEY,JSON.stringify(data));localStorage.setItem(legacy,JSON.stringify(data));};
  window.resetAfterStore=function(){localStorage.removeItem(KEY);localStorage.removeItem(legacy);};
})();
