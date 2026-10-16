/* AFTER cloud product catalogue. Uses only the public/publishable key. */
(function(){
  const client=window.afterSupabase;
  if(!client) return;
  const key=window.AFTER_STORE_KEY||'afterStoreConfigV2';
  const fmt=v=>{if(v===null||v===undefined||v==='')return ''; const n=Number(v); return Number.isFinite(n)?'৳'+n.toLocaleString('en-US'):String(v)};
  async function sync(){
    try{
      const {data,error}=await client.from('products').select('id,name,category,price,old_price,tag,image,images,description,is_best_seller,is_new_arrival,client_id,created_at').order('created_at',{ascending:true});
      if(error||!data||!data.length) return;
      const products=data.map((p,i)=>({
        id:String(p.client_id||p.id),client_id:p.client_id||null,name:p.name||'',category:p.category||'',price:fmt(p.price),oldPrice:fmt(p.old_price),
        tag:p.tag||'',image:p.image||'',description:p.description||'',featured:!!p.is_best_seller,new:!!p.is_new_arrival,
        rating:'4.8',reviews:'0',features:[],images:(Array.isArray(p.images)&&p.images.length?p.images:[p.image||'']).filter(Boolean)
      }));
      const saved=JSON.parse(localStorage.getItem(key)||'{}');
      const signature=arr=>JSON.stringify(arr.map(p=>[p.id,p.name,p.category,p.price,p.oldPrice,p.tag,p.image,JSON.stringify(p.images||[]),p.description,p.featured,p.new]));
      if(signature(saved.products||[])!==signature(products)){
        saved.products=products; localStorage.setItem(key,JSON.stringify(saved));
        location.reload();
      }
    }catch(e){console.warn('Cloud product sync unavailable; using cached products.',e)}
  }
  sync();
})();
